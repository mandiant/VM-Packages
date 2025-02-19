"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.writeFilesystem = writeFilesystem;
exports.readArchiveHeaderSync = readArchiveHeaderSync;
exports.readFilesystemSync = readFilesystemSync;
exports.uncacheFilesystem = uncacheFilesystem;
exports.uncacheAll = uncacheAll;
exports.readFileSync = readFileSync;
const path = __importStar(require("path"));
const wrapped_fs_1 = __importDefault(require("./wrapped-fs"));
const pickle_1 = require("./pickle");
const filesystem_1 = require("./filesystem");
let filesystemCache = Object.create(null);
async function copyFile(dest, src, filename) {
    const srcFile = path.join(src, filename);
    const targetFile = path.join(dest, filename);
    const [content, stats] = await Promise.all([
        wrapped_fs_1.default.readFile(srcFile),
        wrapped_fs_1.default.stat(srcFile),
        wrapped_fs_1.default.mkdirp(path.dirname(targetFile)),
    ]);
    return wrapped_fs_1.default.writeFile(targetFile, content, { mode: stats.mode });
}
async function streamTransformedFile(originalFilename, outStream, transformed) {
    return new Promise((resolve, reject) => {
        const stream = wrapped_fs_1.default.createReadStream(transformed ? transformed.path : originalFilename);
        stream.pipe(outStream, { end: false });
        stream.on('error', reject);
        stream.on('end', () => resolve());
    });
}
const writeFileListToStream = async function (dest, filesystem, out, fileList, metadata) {
    for (const file of fileList) {
        if (file.unpack) {
            // the file should not be packed into archive
            const filename = path.relative(filesystem.getRootPath(), file.filename);
            await copyFile(`${dest}.unpacked`, filesystem.getRootPath(), filename);
        }
        else {
            await streamTransformedFile(file.filename, out, metadata[file.filename].transformed);
        }
    }
    return out.end();
};
async function writeFilesystem(dest, filesystem, fileList, metadata) {
    const headerPickle = pickle_1.Pickle.createEmpty();
    headerPickle.writeString(JSON.stringify(filesystem.getHeader()));
    const headerBuf = headerPickle.toBuffer();
    const sizePickle = pickle_1.Pickle.createEmpty();
    sizePickle.writeUInt32(headerBuf.length);
    const sizeBuf = sizePickle.toBuffer();
    const out = wrapped_fs_1.default.createWriteStream(dest);
    await new Promise((resolve, reject) => {
        out.on('error', reject);
        out.write(sizeBuf);
        return out.write(headerBuf, () => resolve());
    });
    return writeFileListToStream(dest, filesystem, out, fileList, metadata);
}
function readArchiveHeaderSync(archivePath) {
    const fd = wrapped_fs_1.default.openSync(archivePath, 'r');
    let size;
    let headerBuf;
    try {
        const sizeBuf = Buffer.alloc(8);
        if (wrapped_fs_1.default.readSync(fd, sizeBuf, 0, 8, null) !== 8) {
            throw new Error('Unable to read header size');
        }
        const sizePickle = pickle_1.Pickle.createFromBuffer(sizeBuf);
        size = sizePickle.createIterator().readUInt32();
        headerBuf = Buffer.alloc(size);
        if (wrapped_fs_1.default.readSync(fd, headerBuf, 0, size, null) !== size) {
            throw new Error('Unable to read header');
        }
    }
    finally {
        wrapped_fs_1.default.closeSync(fd);
    }
    const headerPickle = pickle_1.Pickle.createFromBuffer(headerBuf);
    const header = headerPickle.createIterator().readString();
    return { headerString: header, header: JSON.parse(header), headerSize: size };
}
function readFilesystemSync(archivePath) {
    if (!filesystemCache[archivePath]) {
        const header = readArchiveHeaderSync(archivePath);
        const filesystem = new filesystem_1.Filesystem(archivePath);
        filesystem.setHeader(header.header, header.headerSize);
        filesystemCache[archivePath] = filesystem;
    }
    return filesystemCache[archivePath];
}
function uncacheFilesystem(archivePath) {
    if (filesystemCache[archivePath]) {
        filesystemCache[archivePath] = undefined;
        return true;
    }
    return false;
}
function uncacheAll() {
    filesystemCache = {};
}
function readFileSync(filesystem, filename, info) {
    let buffer = Buffer.alloc(info.size);
    if (info.size <= 0) {
        return buffer;
    }
    if (info.unpacked) {
        // it's an unpacked file, copy it.
        buffer = wrapped_fs_1.default.readFileSync(path.join(`${filesystem.getRootPath()}.unpacked`, filename));
    }
    else {
        // Node throws an exception when reading 0 bytes into a 0-size buffer,
        // so we short-circuit the read in this case.
        const fd = wrapped_fs_1.default.openSync(filesystem.getRootPath(), 'r');
        try {
            const offset = 8 + filesystem.getHeaderSize() + parseInt(info.offset);
            wrapped_fs_1.default.readSync(fd, buffer, 0, info.size, offset);
        }
        finally {
            wrapped_fs_1.default.closeSync(fd);
        }
    }
    return buffer;
}
//# sourceMappingURL=disk.js.map