# mymc.sh

A Bash script to upload or download files to/from a MinIO S3-compatible storage service using environment variables stored in a `.env` file.

## Prerequisites

- Ensure the `mc` command-line tool is installed and configured.
- Create a `.env` file in the same directory as `mymc.sh` with the following content:
  ```
  MC_ALIAS=mci
  MC_HOST=https://s3.data.aip.de:9000
  MC_ACCESS_KEY=your_access_key
  MC_SECRET_KEY=your_secret_key
  ```

## Usage

Run the script with the source and destination paths as arguments:

```bash
./mymc.sh local_file_or_dir s3:bucket/path
```

- To upload a local file or directory to MinIO, provide the local path as the first argument and the S3 path as the second argument.
- To download from MinIO, provide the S3 path as the first argument and the local destination path as the second argument.

## Example

Upload a local directory to MinIO:

```bash
./mymc.sh /path/to/local/dir s3:my-bucket/my-dir
```

Download a directory from MinIO:

```bash
./mymc.sh s3:my-bucket/my-dir /path/to/local/dir
```

## Error Handling

The script checks for the presence of the `.env` file and exits with an error message if it is not found.
