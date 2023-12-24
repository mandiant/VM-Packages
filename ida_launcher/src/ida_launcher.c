#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function to compare IDA versions
int compareVersions(int major1, int minor1, int major2, int minor2) {
    if (major1 != major2) {
        return major1 - major2;
    }
    return minor1 - minor2;
}

// Function to search registry key for the highest version of IDA installation
int findHighestIdaVersion(HKEY rootKey, LPCSTR subKey, LPCSTR idaIdentifier, LPSTR path, DWORD pathSize) {
    HKEY hKey;
    DWORD dwIndex = 0;
    char keyName[260];
    char displayName[260];
    LONG lRes;
    int highestMajor = -1, highestMinor = -1;
    BOOL found = FALSE;

    lRes = RegOpenKeyExA(rootKey, subKey, 0, KEY_READ, &hKey);
    if (lRes != ERROR_SUCCESS) {
        return 0; // Unable to open registry key
    }

    while (TRUE) {
        DWORD dwKeyNameSize = sizeof(keyName);
        lRes = RegEnumKeyExA(hKey, dwIndex, keyName, &dwKeyNameSize, NULL, NULL, NULL, NULL);
        if (lRes != ERROR_SUCCESS) {
            break; // No more keys or an error occurred
        }

        HKEY hSubKey;
        lRes = RegOpenKeyExA(hKey, keyName, 0, KEY_READ, &hSubKey);
        if (lRes == ERROR_SUCCESS) {
            DWORD displayNameSize = sizeof(displayName);
            lRes = RegQueryValueExA(hSubKey, "DisplayName", NULL, NULL, (LPBYTE)displayName, &displayNameSize);
            if (lRes == ERROR_SUCCESS && strstr(displayName, idaIdentifier) != NULL) {
                DWORD majorVersion = 0, minorVersion = 0;
                DWORD majorSize = sizeof(majorVersion), minorSize = sizeof(minorVersion);
                RegQueryValueExA(hSubKey, "MajorVersion", NULL, NULL, (LPBYTE)&majorVersion, &majorSize);
                RegQueryValueExA(hSubKey, "MinorVersion", NULL, NULL, (LPBYTE)&minorVersion, &minorSize);

                if (compareVersions(majorVersion, minorVersion, highestMajor, highestMinor) > 0) {
                    highestMajor = majorVersion;
                    highestMinor = minorVersion;
                    DWORD valueSize = pathSize;
                    lRes = RegQueryValueExA(hSubKey, "InstallLocation", NULL, NULL, (LPBYTE)path, &valueSize);
                    found = (lRes == ERROR_SUCCESS);
                }
            }
            RegCloseKey(hSubKey);
        }
        dwIndex++;
    }

    RegCloseKey(hKey);
    return found;
}

// WinMain entry point
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
    char idaPath[260] = {0};
    DWORD dwSize = sizeof(idaPath);

    // Search for the highest version of IDA Pro first
    if (!findHighestIdaVersion(HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall", "IDA Pro", idaPath, dwSize)) {
        // If IDA Pro not found, search for the highest version of IDA Freeware
        if (!findHighestIdaVersion(HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall", "IDA Freeware", idaPath, dwSize)) {
            MessageBox(NULL, "IDA not found.", "Error", MB_OK | MB_ICONERROR);
            return 1;
        }
    }

    // Append ida64.exe to the path
    strcat(idaPath, "\\ida64.exe");

    // Check if a file path is provided as an argument
    if (strlen(lpCmdLine) > 0) {
        // Attempt to open IDA with the provided file
        ShellExecute(NULL, "open", idaPath, lpCmdLine, NULL, SW_SHOW);
    } else {
        // Just open IDA if no file is provided
        ShellExecute(NULL, "open", idaPath, NULL, NULL, SW_SHOW);
    }

    return 0;
}
