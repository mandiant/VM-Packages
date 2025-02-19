import { FilesystemDirectoryEntry, FilesystemEntry, FilesystemLinkEntry } from './filesystem';
import * as disk from './disk';
import { IOptions } from './types/glob';
export declare function createPackage(src: string, dest: string): Promise<NodeJS.WritableStream>;
export type CreateOptions = {
    dot?: boolean;
    globOptions?: IOptions;
    ordering?: string;
    pattern?: string;
    transform?: (filePath: string) => NodeJS.ReadWriteStream | void;
    unpack?: string;
    unpackDir?: string;
};
export declare function createPackageWithOptions(src: string, dest: string, options: CreateOptions): Promise<NodeJS.WritableStream>;
/**
 * Create an ASAR archive from a list of filenames.
 *
 * @param src - Base path. All files are relative to this.
 * @param dest - Archive filename (& path).
 * @param filenames - List of filenames relative to src.
 * @param [metadata] - Object with filenames as keys and {type='directory|file|link', stat: fs.stat} as values. (Optional)
 * @param [options] - Options passed to `createPackageWithOptions`.
 */
export declare function createPackageFromFiles(src: string, dest: string, filenames: string[], metadata?: disk.InputMetadata, options?: CreateOptions): Promise<NodeJS.WritableStream>;
export declare function statFile(archivePath: string, filename: string, followLinks?: boolean): FilesystemEntry;
export declare function getRawHeader(archivePath: string): disk.ArchiveHeader;
export interface ListOptions {
    isPack: boolean;
}
export declare function listPackage(archivePath: string, options: ListOptions): string[];
export declare function extractFile(archivePath: string, filename: string, followLinks?: boolean): Buffer;
export declare function extractAll(archivePath: string, dest: string): void;
export declare function uncache(archivePath: string): boolean;
export declare function uncacheAll(): void;
export { EntryMetadata } from './filesystem';
export { InputMetadata, DirectoryRecord, FileRecord, ArchiveHeader } from './disk';
export type InputMetadataType = 'directory' | 'file' | 'link';
export type DirectoryMetadata = FilesystemDirectoryEntry;
export type FileMetadata = FilesystemEntry;
export type LinkMetadata = FilesystemLinkEntry;
declare const _default: {
    createPackage: typeof createPackage;
    createPackageWithOptions: typeof createPackageWithOptions;
    createPackageFromFiles: typeof createPackageFromFiles;
    statFile: typeof statFile;
    getRawHeader: typeof getRawHeader;
    listPackage: typeof listPackage;
    extractFile: typeof extractFile;
    extractAll: typeof extractAll;
    uncache: typeof uncache;
    uncacheAll: typeof uncacheAll;
};
export default _default;
