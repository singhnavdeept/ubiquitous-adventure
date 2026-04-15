---
tags:
  - concept/remembring
  - theory
Priority: Medium
Scope: less
banner: "[[a_group_of_people_in_a_room.jpg]]"
---

### 📂 1. Basic Navigation & Listing

| Command     | Description & Example                                                                                           |
| :---------- | :-------------------------------------------------------------------------------------------------------------- |
| `-ls`       | Lists files and directories in the given path. Use `-R` for recursive listing.                                  |
|             | **Example:** `hdfs dfs -ls /user/hadoop/data`                                                                   |
|             | **Example:** `hdfs dfs -ls -R /data`                                                                            |
| `-cat`      | Prints the content of a file to the console. Best for small files.                                              |
|             | **Example:** `hdfs dfs -cat /user/hadoop/notes.txt`                                                             |
| `-tail`     | Shows the last kilobyte of a file. Use `-f` to follow the file as it grows.                                     |
|             | **Example:** `hdfs dfs -tail /var/log/app.log`                                                                  |
| `-head      | Displays the first kilobyte of a file.                                                                          |
|             | **Example:** `hdfs dfs -head /user/hadoop/bigfile.csv`                                                          |
| `-text`     | Takes a file and outputs it in text format. Useful for reading sequence files or compressed files (like `.gz`). |
|             | **Example:** `hdfs dfs -text /user/hadoop/data.gz`                                                              |
| `-checksum` | Returns the checksum information for a file. Useful for verifying data integrity.                               |
|             | **Example:** `hdfs dfs -checksum /user/hadoop/important_data.parquet`                                           |

### 📁 2. File & Directory Creation

| Command | Description & Example |
| :--- | :--- |
| `-mkdir` | Creates a new directory. Use `-p` to create parent directories if they do not exist. |
| | **Example:** `hdfs dfs -mkdir /user/hadoop/new_project` |
| | **Example:** `hdfs dfs -mkdir -p /user/hadoop/raw/year=2024/month=01` |
| `-touchz` | Creates an empty file (0 bytes). Often used as a marker or for testing. |
| | **Example:** `hdfs dfs -touchz /user/hadoop/job_completed.marker` |

### ⬆️⬇️ 3. Uploading & Downloading Files

| Command          | Description & Example                                                                                                                            |
| :--------------- | :----------------------------------------------------------------------------------------------------------------------------------------------- |
| `-put`           | Copies a file or directory from your local file system to HDFS.                                                                                  |
|                  | **Example:** `hdfs dfs -put ./local_file.csv /user/hadoop/data/`                                                                                 |
|                  | **Example:** `hdfs dfs -put -f ./local_dir/ /user/hadoop/data/` (The `-f` flag forces overwrite)                                                 |
| `-copyFromLocal` | Similar to `-put`, copies files from the local file system to HDFS.                                                                              |
|                  | **Example:** `hdfs dfs -copyFromLocal ./local_file.txt /user/hadoop/`                                                                            |
| `-moveFromLocal` | Moves (cuts) a file from the local file system to HDFS, deleting the local copy after a successful upload.                                       |
|                  | **Example:** `hdfs dfs -moveFromLocal ./local_file.csv /user/hadoop/data/`                                                                       |
| `-get`           | Copies a file or directory from HDFS to your local file system.                                                                                  |
|                  | **Example:** `hdfs dfs -get /user/hadoop/output/result.txt ./`                                                                                   |
| `-copyToLocal`   | Similar to `-get`, copies files from HDFS to the local file system.                                                                              |
|                  | **Example:** `hdfs dfs -copyToLocal /user/hadoop/archive.gz /tmp/`                                                                               |
| `-getmerge`      | Merges multiple files from an HDFS directory into a single local file. Often used to combine the output of a MapReduce job.                      |
|                  | **Example:** `hdfs dfs -getmerge /user/hadoop/job_output/ ./final_result.txt`                                                                    |
|                  | **Example:** `hdfs dfs -getmerge -nl /user/hadoop/job_output/ ./final_result.txt` (The `-nl` flag adds a newline character between merged files) |

### ✏️ 4. File Manipulation (Copy, Move, Append, Merge)

| Command         | Description & Example                                                                                            |
| :-------------- | :--------------------------------------------------------------------------------------------------------------- |
| `-cp`           | Copies a file or directory from one HDFS location to another.                                                    |
|                 | **Example:** `hdfs dfs -cp /user/hadoop/file.txt /user/hadoop/backup/`                                           |
| `-mv`           | Moves or renames a file or directory within HDFS.                                                                |
|                 | **Example:** `hdfs dfs -mv /user/hadoop/old_name.txt /user/hadoop/new_name.txt`                                  |
|                 | **Example:** `hdfs dfs -mv /user/hadoop/temp_data/ /user/hadoop/archive/`                                        |
| `-appendToFile` | Appends the contents of one or more local files to an existing file in HDFS.                                     |
|                 | **Example:** `hdfs dfs -appendToFile ./new_log_entries.log /user/hadoop/logs/combined.log`                       |
|                 | **Example:** `hdfs dfs -appendToFile ./file1.txt ./file2.txt /user/hadoop/big_file.txt` (Appends multiple files) |

### ℹ️ 5. File Information & Metadata

| Command | Description & Example |
| :--- | :--- |
| `-du` | Shows the disk usage (size) of files and directories. Use `-h` for human-readable format and `-s` for a summary. |
| | **Example:** `hdfs dfs -du -h /user/hadoop/data/` |
| | **Example:** `hdfs dfs -du -s /user/hadoop/` (Shows the total size of a directory) |
| `-count` | Counts the number of directories, files, and bytes under a given path. |
| | **Example:** `hdfs dfs -count /user/hadoop/data/` |
| | **Example:** `hdfs dfs -count -v -h /user/hadoop/data/` (The `-v` flag adds a header line, `-h` makes sizes human-readable) |
| `-stat` | Prints detailed statistics about a file or directory in a specified format. |
| | **Example:** `hdfs dfs -stat "%F %b %o %r %n" /user/hadoop/file.txt` (Prints type, size in bytes, block size, replication, and name) |
| | **Example:** `hdfs fs -stat "type:%F perm:%a %u:%g size:%b mtime:%y" /file` |

### 🔒 6. Permissions & Ownership

| Command  | Description & Example                                                                                |
| :------- | :--------------------------------------------------------------------------------------------------- |
| `-chmod` | Changes the permissions of a file or directory. Use `-R` for recursive changes.                      |
|          | **Example:** `hdfs dfs -chmod 755 /user/hadoop/script.sh`                                            |
| `-chown` | Changes the owner (and optionally the group) of a file or directory. Use `-R` for recursive changes. |
|          | **Example:** `hdfs dfs -chown new_owner:new_group /user/hadoop/data.csv`                             |
| `-chgrp` | Changes the group association of a file or directory. Use `-R` for recursive changes.                |
|          | **Example:** `hdfs dfs -chgrp analysts /user/hadoop/reports/`                                        |

### ✅ 7. File Testing & Validation

| Command | Description & Example                                                                                    |
| :------ | :------------------------------------------------------------------------------------------------------- |
| `-test` | Performs a test on a file or directory. Returns 0 if true, 1 if false.                                   |
|         | **Test options:** `-e` (exists), `-z` (is zero length), `-d` (is a directory), `-f` (is a regular file). |
|         | **Example:** `hdfs dfs -test -e /user/hadoop/data.csv && echo "File exists"`                             |
|         | **Example:** `hdfs dfs -test -z /user/hadoop/empty.log && echo "File is empty"`                          |

### 🗑️ 8. Deletion & Cleanup

| Command | Description & Example |
| :--- | :--- |
| `-rm` | Deletes a file. It will be moved to the HDFS trash (`.Trash`) by default. |
| | **Example:** `hdfs dfs -rm /user/hadoop/temp_data.csv` |
| `-rm -r` | Recursively deletes a directory and all its contents. Use with caution. |
| | **Example:** `hdfs dfs -rm -r /user/hadoop/old_project/` |
| `-rm -skipTrash` | Permanently deletes a file immediately, bypassing the trash. |
| | **Example:** `hdfs dfs -rm -skipTrash /user/hadoop/sensitive_data.csv` |
| `-expunge` | Empties the HDFS trash, permanently deleting the files in it. |
| | **Example:** `hdfs dfs -expunge` |

### 🚀 9. Advanced Operations

| Command | Description & Example |
| :--- | :--- |
| `-setrep` | Changes the replication factor of a file. Use `-R` for recursive changes and `-w` to wait for the replication to complete. |
| | **Example:** `hdfs dfs -setrep 5 /user/hadoop/critical_data.parquet` (Sets replication to 5) |
| | **Example:** `hdfs dfs -setrep -w -R 2 /user/hadoop/archive/` (Recursively sets replication to 2 for all files in the directory and waits) |
| `-df` | Shows the capacity, used space, and free space of the entire HDFS filesystem. |
| | **Example:** `hdfs dfs -df -h` (The `-h` flag gives human-readable output) |

### ⚙️ 10. Administration Commands (`hdfs dfsadmin`)

| Command | Description & Example |
| :--- | :--- |
| `-report` | Generates a comprehensive report on the HDFS cluster's health, including capacity, blocks, and the status of each DataNode. |
| | **Example:** `hdfs dfsadmin -report` |
| `-safemode` | Manages HDFS safe mode. The cluster is read-only during safe mode. |
| | **Example:** `hdfs dfsadmin -safemode get` (Checks if safe mode is on) |
| | **Example:** `hdfs dfsadmin -safemode leave` (Forces the cluster to leave safe mode) |




# EXAMPLES


### 🛠️ Step 1: Setup - Create Local Files

First, let's create a temporary directory on your local machine and generate some sample data files.

```bash
# Create a local working directory
mkdir ~/hdfs_demo
cd ~/hdfs_demo

# Create File 1: employees.csv
echo "id,name,department" > employees.csv
echo "101,John,Engineering" >> employees.csv
echo "102,Sarah,Marketing" >> employees.csv

# Create File 2: new_hires.csv
echo "id,name,department" > new_hires.csv
echo "201,Alex,Engineering" >> new_hires.csv

# Create File 3: daily_logs.txt (to be used for appending later)
echo "[INFO] System startup at 08:00" > daily_logs.txt
```

**Result:** You now have three local files: `employees.csv`, `new_hires.csv`, and `daily_logs.txt`.

---

### ⬆️ Step 2: Move/Copy Files from Local to HDFS

We'll use `-put` to upload the first file, and `-moveFromLocal` to upload the second file (deleting the local copy).

```bash
# 1. Copy employees.csv to HDFS (local copy remains)
hdfs dfs -put employees.csv /user/hadoop/demo/

# 2. MOVE new_hires.csv to HDFS (local copy will be deleted)
hdfs dfs -moveFromLocal new_hires.csv /user/hadoop/demo/

# Verify the upload: List the HDFS directory
hdfs dfs -ls /user/hadoop/demo/
```

**Expected Output:**
```
Found 2 items
-rw-r--r--   1 hadoop supergroup         58 2026-04-15 10:30 /user/hadoop/demo/employees.csv
-rw-r--r--   1 hadoop supergroup         50 2026-04-15 10:30 /user/hadoop/demo/new_hires.csv
```

*Notice:* If you check your local folder now (`ls ~/hdfs_demo`), `new_hires.csv` is gone because we used `-moveFromLocal`. `employees.csv` is still there.

---

### ✅ Step 3: Check if a File Exists in HDFS

Use the `-test -e` command. It returns exit code `0` if the file exists, and `1` if it doesn't. This is perfect for scripting.

```bash
# Check if the file exists (no output on success)
hdfs dfs -test -e /user/hadoop/demo/employees.csv && echo "File EXISTS" || echo "File NOT FOUND"

# Check a non-existent file
hdfs dfs -test -e /user/hadoop/demo/missing_file.txt && echo "File EXISTS" || echo "File NOT FOUND"
```

**Expected Output:**
```
File EXISTS
File NOT FOUND
```

---

### 📝 Step 4: Append a Local File to an Existing HDFS File

We have a local file `daily_logs.txt`. Let's append its content to `employees.csv` in HDFS (imagine we're adding a log entry to the end of a data file).

```bash
# Append the content of local daily_logs.txt to the HDFS file employees.csv
hdfs dfs -appendToFile daily_logs.txt /user/hadoop/demo/employees.csv

# Verify the append by looking at the last few lines of the HDFS file
hdfs dfs -tail /user/hadoop/demo/employees.csv
```

**Expected Output (from tail):**
```
101,John,Engineering
102,Sarah,Marketing
[INFO] System startup at 08:00
```

*Note:* The `[INFO]` line is now at the bottom of the CSV file. This is a bit messy for a real CSV, but it perfectly demonstrates the append operation.

---

### ⬇️ Step 5: Merge Multiple HDFS Files into One Local File

Finally, we will use `-getmerge` to combine `employees.csv` and `new_hires.csv` from HDFS into a single, consolidated file called `all_staff.csv` on our local machine.

```bash
# Merge all files in the HDFS directory /user/hadoop/demo/ into a single local file
hdfs dfs -getmerge /user/hadoop/demo/ ./all_staff.csv

# OR, to be more precise and add newlines between the merged files:
hdfs dfs -getmerge -nl /user/hadoop/demo/ ./all_staff_nl.csv

# Check the contents of the merged local file
cat all_staff.csv
```

**Expected Output (Contents of `all_staff.csv`):**
```
id,name,department
101,John,Engineering
102,Sarah,Marketing
[INFO] System startup at 08:00
id,name,department
201,Alex,Engineering
```

### 🧹 Cleanup (Optional)

```bash
# Remove the demo directory from HDFS
hdfs dfs -rm -r /user/hadoop/demo/

# Remove the local working folder
cd ~
rm -rf ~/hdfs_demo
```

### 📋 Summary Table of Actions Performed

| Action              | Local State             | HDFS State                       | Command Used              |
| :------------------ | :---------------------- | :------------------------------- | :------------------------ |
| **Create**          | `employees.csv` created | N/A                              | `echo` / `cat`            |
| **Upload (Copy)**   | `employees.csv` stays   | `employees.csv` appears          | `hdfs dfs -put`           |
| **Upload (Move)**   | `new_hires.csv` deleted | `new_hires.csv` appears          | `hdfs dfs -moveFromLocal` |
| **Check Existence** | N/A                     | Verified presence                | `hdfs dfs -test -e`       |
| **Append**          | `daily_logs.txt` stays  | Content added to `employees.csv` | `hdfs dfs -appendToFile`  |
| **Merge**           | `all_staff.csv` created | Both files combined              | `hdfs dfs -getmerge`      |












### 1. Merging Only Selected Files in HDFS

The `hdfs dfs -getmerge <src_dir> <local_dst>` command merges **all** files in a directory. To merge a specific subset, use `-cat` on the exact file paths and pipe the output.

**Example Scenario**  
HDFS directory: `/user/hadoop/logs/` contains:
- `app_20260101.log`
- `app_20260102.log`
- `app_20260103.log`
- `app_20260104.log`

**Goal:** Merge only `app_20260101.log` and `app_20260103.log` into a single file `/user/hadoop/merged_selected.log` in HDFS.

**Command:**
```bash
hdfs dfs -cat /user/hadoop/logs/app_20260101.log /user/hadoop/logs/app_20260103.log | hdfs dfs -put - /user/hadoop/merged_selected.log
```
- `-cat` reads the content of both specified files in order.
- The output is piped (`|`) to `hdfs dfs -put -`, where `-` tells HDFS to read from standard input.
- The merged content is written directly into HDFS at the target path.

**Alternative: Merge to Local File First**  
If you prefer a local intermediate file:
```bash
hdfs dfs -cat /user/hadoop/logs/app_20260101.log /user/hadoop/logs/app_20260103.log > /tmp/merged_local.log
hdfs dfs -put /tmp/merged_local.log /user/hadoop/merged_selected.log
```

> **Note:** For a large number of selected files, using a MapReduce job with a custom `FileInputFormat` (e.g., by providing a list of files via `-files` option) is more efficient, but the `-cat` method is simplest for ad‑hoc tasks.

---

### 2. Moving Selected Files Between HDFS and Local Filesystem

Use `-get` (HDFS → local) or `-put` (local → HDFS) with explicit file names or a glob pattern that matches only the desired files.

#### a) HDFS to Local – Copy Only Selected Files

**Goal:** Copy `app_20260101.log` and `app_20260102.log` from `/user/hadoop/logs/` to the local directory `/home/user/backup/`.

**Command:**
```bash
hdfs dfs -get /user/hadoop/logs/app_20260101.log /user/hadoop/logs/app_20260102.log /home/user/backup/
```
- The last argument is the destination directory.
- You can list as many source files as needed.

**Using a Wildcard (if files share a pattern):**
```bash
hdfs dfs -get /user/hadoop/logs/app_2026010[1-2].log /home/user/backup/
```

#### b) Local to HDFS – Upload Only Selected Files

**Goal:** Upload local files `report_jan.csv` and `report_feb.csv` to HDFS directory `/user/hadoop/reports/`.

**Command:**
```bash
hdfs dfs -put /local/data/report_jan.csv /local/data/report_feb.csv /user/hadoop/reports/
```
- The destination directory must exist.

#### c) Moving Within HDFS (Selected Files to Another HDFS Directory)

To **move** (not copy) selected files from one HDFS directory to another, use `-mv`.

**Goal:** Move `app_20260103.log` from `/user/hadoop/logs/` to `/user/hadoop/archive/`.

**Command:**
```bash
hdfs dfs -mv /user/hadoop/logs/app_20260103.log /user/hadoop/archive/
```
- You can specify multiple source files before the destination directory.

---

### Summary of Key Commands Used

| Operation                             | Command                                                                 |
|---------------------------------------|-------------------------------------------------------------------------|
| Merge selected HDFS files to HDFS     | `hdfs dfs -cat file1 file2 \| hdfs dfs -put - merged_file`              |
| Merge selected HDFS files to local    | `hdfs dfs -cat file1 file2 > local_merged`                              |
| Copy selected HDFS files to local     | `hdfs dfs -get file1 file2 ... local_dir/`                              |
| Copy selected local files to HDFS     | `hdfs dfs -put local1 local2 ... hdfs_dir/`                             |
| Move selected files within HDFS       | `hdfs dfs -mv hdfs_file1 hdfs_file2 ... hdfs_target_dir/`               |

All these commands assume you have proper permissions and the Hadoop client is configured. For extremely large datasets, consider using `distcp` or MapReduce for better performance and fault tolerance.