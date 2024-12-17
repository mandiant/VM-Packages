# This tool checks if internet connectivity exists by reaching out to specific websites and checking if they return expected values and
# display the current state via changes to the background, theme, and icon in the taskbar.
#   * It works even with a tool like FakeNet running (provided it uses the default configuration)
# If internet is detected, the tool:
#   - Changes the background to the image "%VM_COMMON_DIR%\background-dynamic.png".
#   - Change the the taskbar to be transparent and if the theme is dark mode also the color to "Rose".
#   - Shows the icon "%VM_COMMON_DIR%\indicator_on.ico" in the taskbar.
# If internet is NOT detected, the tool:
#   - Changes the background to the image "%VM_COMMON_DIR%\background.png" (default background image).
#   - Changes the taskbar to be transparent keeping the current theme/color (dark or light).
#   - Shows the icon "%VM_COMMON_DIR%\indicator_off.ico" in the taskbar.
VERSION = "1.0.0"
TOOL_NAME = "internet_detector"

import win32event
import win32api
import win32gui
import win32con
import winerror
import winreg

import threading
import requests
import urllib3
import signal
import ctypes
import time
import os
import re

# Define constants
CHECK_INTERVAL = 2  # Seconds
CONNECT_TEST_URL_AND_RESPONSES = {
    "https://www.msftconnecttest.com/connecttest.txt": "Microsoft Connect Test",  # HTTPS Test #1
    "http://www.google.com": "Google",  # HTTP Test
    "https://www.wikipedia.com": "Wikipedia",  # HTTPS Test #2
    "https://www.youtube.com": "YouTube",  # HTTPS Test #3
}
SPI_SETDESKWALLPAPER = 20
SPIF_UPDATEINIFILE = 0x01
SPIF_SENDWININICHANGE = 0x02
WM_DWMCOLORIZATIONCOLORCHANGED = 0x0320
ACCENT_PREVALENCE = 1
ROSE_COLOR = "#C30052"  # Rose Color = #ff5200c3 which correlates to #C30052 before parsing
ROSE_ACCENT_PALETTE = "FFABCE00FF7FB400F74A9200C30052008C003A0069002C004D002000567C7300"
ICON_INDICATOR_ON = os.path.join(os.environ.get("VM_COMMON_DIR"), "indicator_on.ico")
ICON_INDICATOR_OFF = os.path.join(os.environ.get("VM_COMMON_DIR"), "indicator_off.ico")
DEFAULT_BACKGROUND = os.path.join(os.environ.get("VM_COMMON_DIR"), "background.png")
INTERNET_BACKGROUND = os.path.join(os.environ.get("VM_COMMON_DIR"), "background-internet.png")
REGISTRY_PATH = r"Software\InternetDetector"

# Global variables
tray_icon = None
stop_event = threading.Event()  # To signal the background thread to stop
hwnd = None  # We'll assign the window handle here later
check_thread = None
tray_icon_thread = None
default_transparency = None
default_color_prevalence = None
default_color = None
default_palette = None
# Win32 API icon handles
hicon_indicator_off = None
hicon_indicator_on = None
mutex = None

def is_already_running():
    global mutex
    # Try to create a mutex with a unique name.
    mutex_name = f"{{{os.path.basename(__file__).replace('.py', '')}}}"  # Use filename as part of mutex name
    try:
        mutex = win32event.CreateMutex(None, False, mutex_name)  # False means don't acquire initially
        return winerror.ERROR_ALREADY_EXISTS == win32api.GetLastError()
    except Exception as e:
        print(f"Mutex creation error: {e}")
        return False  # Assume not running if error

def signal_handler(sig, frame):
    global check_thread, tray_icon_thread, tray_icon, mutex
    print("Ctrl+C detected. Exiting...")
    stop_event.set()  # Signal the background thread to stop
    if check_thread:
        check_thread.join()
    if tray_icon_thread:
        tray_icon_thread.join()
    if tray_icon:
        try:
            del tray_icon
        except Exception as e:
            print(f"Error destroying tray icon: {e}")
    if mutex:
        win32api.CloseHandle(mutex)
    exit(0)

def load_icon(icon_path):
    try:
        return win32gui.LoadImage(None, icon_path, win32con.IMAGE_ICON, 0, 0, win32con.LR_LOADFROMFILE)
    except Exception as e:
        print(f"Error loading indicator icon: {e}")
        return None

class SysTrayIcon:
    def __init__(self, hwnd, icon, tooltip):
        self.hwnd = hwnd
        self.icon = icon
        self.tooltip = tooltip
        self.valid = True
        # System tray icon data structure
        self.nid = (
            self.hwnd,
            0,
            win32gui.NIF_ICON | win32gui.NIF_MESSAGE | win32gui.NIF_TIP,
            win32con.WM_USER + 20,
            self.icon,
            self.tooltip,
        )
        # Add the icon to the system tray
        try:
            win32gui.Shell_NotifyIcon(win32gui.NIM_ADD, self.nid)
        except Exception as e:
            print(f"Error creating tray icon: {e}")
            self.valid = False

    def set_tooltip(self, new_tooltip):
        if not self.valid: return
        self.tooltip = new_tooltip
        self.nid = (
            self.hwnd,
            0,
            win32gui.NIF_ICON | win32gui.NIF_MESSAGE | win32gui.NIF_TIP,
            win32con.WM_USER + 20,
            self.icon,
            self.tooltip,
        )
        try:
            win32gui.Shell_NotifyIcon(win32gui.NIM_MODIFY, self.nid)
        except Exception as e:
            print(f"Error modifying tray icon tooltip: {e}")
            self.valid = False

    def set_icon(self, icon):
        if not self.valid: return
        self.icon = icon
        self.nid = (
            self.hwnd,
            0,
            win32gui.NIF_ICON | win32gui.NIF_MESSAGE | win32gui.NIF_TIP,
            win32con.WM_USER + 20,
            self.icon,
            self.tooltip,
        )
        try:
            win32gui.Shell_NotifyIcon(win32gui.NIM_MODIFY, self.nid)
        except Exception as e:
            print(f"Error modifying tray icon image: {e}")
            self.valid = False

    def __del__(self):
        # Remove the icon from the system tray when the object is destroyed
        if not self.valid: return
        try:
            win32gui.Shell_NotifyIcon(win32gui.NIM_DELETE, self.nid)
        except Exception as e:
            print(f"Error deleting tray icon: {e}")
            self.valid = False

def get_current_color_prevalence():
    try:
        # Open the registry key for accent palette settings
        key = winreg.OpenKey(
            winreg.HKEY_CURRENT_USER, 
            r"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", 
            0, 
            winreg.KEY_READ
        )
        value, _ = winreg.QueryValueEx(key, "ColorPrevalence")
        winreg.CloseKey(key)
        return value

    except WindowsError:
        print("Error accessing registry.")
        return None

# Reads color palette binary data from a registry key and returns it as a hex string.
def get_current_color_palette():
    try:
        # Open the registry key for accent palette settings
        key = winreg.OpenKey(
            winreg.HKEY_CURRENT_USER,
            r"Software\Microsoft\Windows\CurrentVersion\Explorer\Accent",
            0,
            winreg.KEY_READ
        )
        value, _ = winreg.QueryValueEx(key, "AccentPalette")
        winreg.CloseKey(key)
        # return the data as hex string
        return value.hex()

    except WindowsError:
        print("Error accessing registry.")
        return None

# Attempts to get the current taskbar color based on user personalization settings and returns it in hex format.
def get_current_taskbar_color():
    try:
        # Open the registry key for personalization settings
        key = winreg.OpenKey(
            winreg.HKEY_CURRENT_USER,
            r"Software\Microsoft\Windows\CurrentVersion\Explorer\Accent",
            0,
            winreg.KEY_READ
        )
        accent_color, _ = winreg.QueryValueEx(key, "AccentColorMenu")
        winreg.CloseKey(key)

        # Convert the accent color value (DWORD) to RGB
        r = accent_color & 0xFF
        g = (accent_color >> 8) & 0xFF
        b = (accent_color >> 16) & 0xFF
        # Convert RGB to hex
        return f"#{r:02X}{g:02X}{b:02X}"

    except WindowsError:
        print("Error accessing registry.")
        return None

def set_taskbar_accent_color(hex_color, hex_color_palette, color_prevalence):
    """
    Sets the accent color location in the Windows registry.

    Args:
        hex_color = the hex value of RGB color with starting "#" (e.g., '#RRGGBB')
        hex_color_palette = the hex string of the corresponding color paletter for the provided hex_color
        color_prevalence = 0 - don't use accent color; 1 - use accent color
    """
    try:
        print("Setting taskbar color to:", hex_color)
        # Convert hex color to RGB
        r = int(hex_color[1:3], 16)
        g = int(hex_color[3:5], 16)
        b = int(hex_color[5:7], 16)

        # Convert RGB to DWORD
        color_value = (b << 16) | (g << 8) | r

        key = winreg.OpenKey(
            winreg.HKEY_CURRENT_USER,
            r"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize",
            0,
            winreg.KEY_ALL_ACCESS
        )
        winreg.SetValueEx(key, "AccentColorPolicy", 0, winreg.REG_DWORD, 1)     # Set color for taskbar
        winreg.SetValueEx(key, "ColorPrevalence", 0, winreg.REG_DWORD, color_prevalence)       # Enable accent color
        winreg.SetValueEx(key, "AccentColorInactive", 0, winreg.REG_DWORD, 0)   # Disable inactive color
        winreg.CloseKey(key)

        key = winreg.OpenKey(
            winreg.HKEY_CURRENT_USER,
            r"Software\Microsoft\Windows\CurrentVersion\Explorer\Accent",
            0,
            winreg.KEY_ALL_ACCESS,
        )
        binary_data = bytes.fromhex(hex_color_palette)
        winreg.SetValueEx(key, "AccentColorMenu", 0, winreg.REG_DWORD, color_value)
        winreg.SetValueEx(key, "AccentPalette", 0, winreg.REG_BINARY, binary_data)
        winreg.CloseKey(key)

    except WindowsError as e:
        print(f"Error accessing or modifying registry: {e}")

def get_transparency_effects():
    try:
        key = winreg.OpenKey(
            winreg.HKEY_CURRENT_USER,
            r"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize",
            0,
            winreg.KEY_ALL_ACCESS,
        )
        value, _ = winreg.QueryValueEx(key, "EnableTransparency")
        winreg.CloseKey(key)
        return value

    except WindowsError as e:
        print(f"Error accessing or modifying registry: {e}")

def set_transparency_effects(value):
    try:
        key = winreg.OpenKey(
            winreg.HKEY_CURRENT_USER,
            r"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize",
            0,
            winreg.KEY_ALL_ACCESS,
        )

        winreg.SetValueEx(key, "EnableTransparency", 0, winreg.REG_DWORD, value)
        winreg.CloseKey(key)
    except WindowsError as e:
        print(f"Error accessing or modifying registry: {e}")

# Attempt to extract a known good value in response.
def extract_title(data):
    match = re.search(r"<title>(.*?)</title>", data)
    if match:
        return match.group(1)
    else:
        return None

def check_internet():
    for url, expected_response in CONNECT_TEST_URL_AND_RESPONSES.items():
        try:
            # Perform internet connectivity tests
            response = requests.get(url, timeout=5, verify=False)
            if expected_response in (extract_title(response.text) or response.text):
                print(f"Internet connectivity detected via URL: {url}")
                return True
        except:
            pass
    return False

def check_internet_and_update_tray_icon():
    global tray_icon, hicon_indicator_off, hicon_indicator_on, default_color
    if check_internet():
        tray_icon.set_icon(hicon_indicator_on)
        tray_icon.set_tooltip("Internet Connection: Detected")
        set_transparency_effects(1)
        set_taskbar_accent_color(ROSE_COLOR, ROSE_ACCENT_PALETTE, ACCENT_PREVALENCE)
        # Set the background to internet connection background
        if get_wallpaper_path() != INTERNET_BACKGROUND:  # Checked so program isn't continuously setting the wallpaper
            set_wallpaper(INTERNET_BACKGROUND)
    else:
        tray_icon.set_icon(hicon_indicator_off)
        tray_icon.set_tooltip("Internet Connection: Not Detected")
        set_transparency_effects(default_transparency)
        set_taskbar_accent_color(default_color, default_palette, default_color_prevalence)  # change color back to what user had originally
        # Reset background when internet is not detected
        if get_wallpaper_path() != DEFAULT_BACKGROUND:  # Checked so program isn't continuously setting the wallpaper
            set_wallpaper(DEFAULT_BACKGROUND)

def check_internet_loop():
    global tray_icon
    while not stop_event.is_set():
        if tray_icon and tray_icon.valid:
            check_internet_and_update_tray_icon()
            time.sleep(CHECK_INTERVAL)
        else:
            print("Tray icon is invalid. Exiting check_internet_loop.")
            stop_event.set()
            if tray_icon:
                del tray_icon
                tray_icon = None

            # Restart the tray icon and check_internet threads
            tray_icon_thread = threading.Thread(target=tray_icon_loop)
            tray_icon_thread.start()
            # Wait for the tray icon to finish initializing
            while tray_icon is None:
                time.sleep(0.1)
            check_thread = threading.Thread(target=check_internet_loop)
            check_thread.start()
            return

def tray_icon_loop():
    global hwnd, tray_icon, hicon_indicator_off, hicon_indicator_on, stop_event
    # Load icons
    hicon_indicator_off = load_icon(ICON_INDICATOR_OFF)
    hicon_indicator_on = load_icon(ICON_INDICATOR_ON)

    # Wait for hwnd to be initialized
    while hwnd is None:
        time.sleep(0.1)

    if hicon_indicator_off is None or hicon_indicator_on is None:
        print("Error: Failed to load icons. Exiting TrayIconThread.")
        return

    tray_icon = SysTrayIcon(hwnd, hicon_indicator_off, "Internet Detector")

    while not stop_event.is_set():
        # Use PeekMessage to avoid blocking and allow thread exit
        ret, msg = win32gui.PeekMessage(hwnd, 0, 0, win32con.PM_REMOVE)
        if ret != 0:
            win32gui.TranslateMessage(msg)
            win32gui.DispatchMessage(msg)
        time.sleep(0.1)

def get_wallpaper_path():
    """Attempts to retrieve the path to the current wallpaper image."""
    # Try to get the path from the registry (for wallpapers set through Windows settings)
    try:
        key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Control Panel\Desktop", 0, winreg.KEY_READ)
        value, _ = winreg.QueryValueEx(key, "Wallpaper")
        winreg.CloseKey(key)
        if value:
            return value
    except WindowsError:
        pass

    # Check for cached wallpaper files (if the above fails)
    cached_files_dir = os.path.join(os.getenv("APPDATA"), r"Microsoft\Windows\Themes\CachedFiles")
    transcoded_wallpaper_path = os.path.join(os.getenv("APPDATA"), r"Microsoft\Windows\Themes\TranscodedWallpaper")

    for file in os.listdir(cached_files_dir):
        if file.endswith((".jpg", ".jpeg", ".bmp", ".png")):
            return os.path.join(cached_files_dir, file)

    if os.path.exists(transcoded_wallpaper_path):
        return transcoded_wallpaper_path

    # If all else fails, return None
    return None

def set_wallpaper(image_path):
    """Sets the desktop wallpaper to the image at the specified path."""
    print(f"Setting wallpaper to: {image_path}")
    result = ctypes.windll.user32.SystemParametersInfoW(
        SPI_SETDESKWALLPAPER, 0, image_path, SPIF_UPDATEINIFILE | SPIF_SENDWININICHANGE
    )
    if not result:
        print("Error setting wallpaper. Make sure the image path is correct.")

def save_default_settings():
    """Saves the default color, palette, and color prevalence to the registry."""
    try:
        key = winreg.CreateKey(winreg.HKEY_CURRENT_USER, REGISTRY_PATH)
        winreg.SetValueEx(key, "DefaultColor", 0, winreg.REG_SZ, default_color)
        winreg.SetValueEx(key, "DefaultPalette", 0, winreg.REG_SZ, default_palette)
        winreg.SetValueEx(key, "DefaultColorPrevalence", 0, winreg.REG_DWORD, default_color_prevalence)
        winreg.CloseKey(key)
        print("Default settings saved to registry.")
    except WindowsError as e:
        print(f"Error saving default settings to registry: {e}")

def load_default_settings():
    """Loads the default color, palette, and color prevalence from the registry."""
    global default_color, default_palette, default_color_prevalence
    try:
        key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, REGISTRY_PATH, 0, winreg.KEY_READ)
        default_color, _ = winreg.QueryValueEx(key, "DefaultColor")
        default_palette, _ = winreg.QueryValueEx(key, "DefaultPalette")
        default_color_prevalence, _ = winreg.QueryValueEx(key, "DefaultColorPrevalence")
        winreg.CloseKey(key)
        print("Default settings loaded from registry.")
        return True
    except WindowsError:
        print("No saved default settings found in registry.")
        return False

def main_loop():
    global stop_event, check_thread, tray_icon_thread, tray_icon, mutex

    if is_already_running():
        print("Another instance is already running. Exiting.")
        return

    # Create and start the threads
    tray_icon_thread = threading.Thread(target=tray_icon_loop)
    check_thread = threading.Thread(target=check_internet_loop)

    tray_icon_thread.start()
    # Wait for the tray icon to finish initializing
    while tray_icon is None:
        time.sleep(0.1)

    check_thread.start()

    while not stop_event.is_set():
        time.sleep(1)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
    default_transparency = get_transparency_effects()

    # Try to load default settings from the registry
    if not load_default_settings():
        # If not found, get the current settings and save them as defaults
        default_color_prevalence = get_current_color_prevalence()
        default_color = get_current_taskbar_color()
        default_palette = get_current_color_palette()
        save_default_settings()

    # Create a hidden window to receive messages (required for system tray icons)
    def wndProc(hwnd, msg, wparam, lparam):
        if lparam == win32con.WM_LBUTTONDBLCLK:
            print("Left button double clicked")
        elif msg == win32con.WM_COMMAND:
            if wparam == 1023:  # Example menu item ID
                print("Exit selected")
                win32gui.DestroyWindow(hwnd)
        return win32gui.DefWindowProc(hwnd, msg, wparam, lparam)

    wc = win32gui.WNDCLASS()
    hinst = wc.hInstance = win32api.GetModuleHandle(None)
    wc.lpszClassName = "Internet Detector"
    wc.lpfnWndProc = wndProc
    classAtom = win32gui.RegisterClass(wc)
    hwnd = win32gui.CreateWindow(classAtom, "Internet Detector", 0, 0, 0, 0, 0, 0, 0, hinst, None)

    print(f"{TOOL_NAME} Version: {VERSION}")
    print(f"Current wallpaper: {get_wallpaper_path()}")
    print(f"Current color: {default_color}")

    main_loop()