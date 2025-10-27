# **Basic Bash Administration Automation**

[![Linux](https://img.shields.io/badge/OS-Linux-blue?logo=linux)](https://www.linux.org/)
[![Bash](https://img.shields.io/badge/Shell-Bash-green?logo=gnubash)](https://www.gnu.org/software/bash/)
[![Automation](https://img.shields.io/badge/Focus-System%20Automation-orange)](https://en.wikipedia.org/wiki/Automation)
[![User Management](https://img.shields.io/badge/Module-User%20Management-yellow)](https://www.geeksforgeeks.org/useradd-command-in-linux/)
[![File Processing](https://img.shields.io/badge/Skill-File%20Processing-lightgrey)](https://en.wikipedia.org/wiki/Input/output)
[![Security](https://img.shields.io/badge/Concept-Permission%20Control-red)](https://en.wikipedia.org/wiki/File-system_permissions)

---

## **Project Overview**

This project demonstrates the use of **Bash scripting** to automate repetitive system administration tasks in a Linux environment.  
As a **junior system administrator**, I developed a script that automates **user account creation**, ensuring each new employee receives a consistent and secure environment with unique credentials and home directories.

The automation improves onboarding efficiency, minimizes manual errors, and enforces secure practices such as **password expiration**, **error handling**, and **log generation**.

---

## **Objectives**

1. Demonstrate the ability to leverage **Bash scripting** for repetitive administrative tasks.  
2. Minimize errors compared to manual account setup.  
3. Ensure all created users have consistent and functional accounts.  
4. Efficiently onboard employees by automating user creation.  

---

## **Scenario**

You are a **junior Linux system administrator** responsible for onboarding new employees.  
Your manager has provided you a list of usernames in a text file (`Users.txt`) and requested an automated method to create user accounts with default passwords.  
Since the list contains hundreds of names, manually creating accounts is inefficient and prone to error.  
This automation script ensures scalable, secure, and consistent user creation.

---

## **Step 1: Verify Root Privileges and Input File**

Before performing user operations, the script checks two essential conditions:

**Logic:**
```bash
if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run as root (use sudo)."
    exit 13
elif [ ! -f "$USER_FILE" ]; then
    echo "Error: User file '$USER_FILE' not found!"
    exit 44
else
    echo "Starting user creation process..."
    echo "---------------------------------"
fi
```

**Explanation:**
- The script must be run as **root** to create system users.  
- If the `Users.txt` file is missing, the process stops safely.  
- The `exit` codes allow clear debugging: `1` (lack of permissions) and `44` (file not found).

---

## **Step 2: Read Usernames from File**

Each line in `Users.txt` represents one username.  
The script reads each name line-by-line using a `while` loop:

```bash
while IFS= read -r username; do
    ...
done < "$USER_FILE"
```

**Explanation:**
- `IFS=` preserves spaces in usernames.  
- `read -r` prevents backslashes from being treated as escape characters.  
- The `< "$USER_FILE"` redirection feeds the file’s contents directly into the loop.  

---

## **Step 3: Skip Empty Lines and Existing Users**

Before creating new accounts, the script avoids unnecessary operations:

```bash
[ -z "$username" ] && continue

if id "$username" &>/dev/null; then
    echo "User $username already exists, skipping..." | tee -a "$LOG_FILE"
    continue
fi
```

**Explanation:**
- `[ -z "$username" ]` skips empty lines in the file.  
- `id "$username"` checks if the user already exists; if so, the script logs and skips them.  
- The `tee -a` command logs messages both on screen and in the log file simultaneously.

---

## **Step 4: Create User and Assign Password**

For each valid new username, the script executes:

```bash
useradd -m "$username" &>/dev/null
echo "${username}:${DEFAULT_PASS}" | chpasswd
passwd -e "$username" &>/dev/null
```

**Explanation:**
- `useradd -m` creates the user and their home directory.  
- `chpasswd` securely sets the default password for automation (non-interactive).  
- `passwd -e` forces a password reset on the next login for security.

---

## **Step 5: Log the Creation Process**

All successful operations are recorded in a log file:

```bash
echo "User $username created successfully." | tee -a "$LOG_FILE"
```

**Explanation:**
- `tee -a` appends each success message to the log file (`Created_Users.log`).  
- The `-a` flag ensures logs are not overwritten when the script is re-run.

---

## **Step 6: Verify Results**

After execution, verification is done using standard Linux commands.

**Check log contents:**
```bash
cat Created_Users.log
```
<img width="386" height="176" alt="image" src="https://github.com/user-attachments/assets/a2f4f8ca-9333-47b5-87e0-7644177a372c" />

**Verify account creation:**
```bash
id RussellAKADusty
```

<img width="711" height="74" alt="image" src="https://github.com/user-attachments/assets/c11baa9b-3fd9-4c64-848b-407a7339d853" />

**Confirm home directories:**
```bash
ls /home
```

<img width="928" height="76" alt="image" src="https://github.com/user-attachments/assets/88325fea-0b62-4d92-b73f-5d9f1965a4bb" />


**Check password status:**
```bash
sudo chage -l RussellAKADusty
```

Output snippet:

<img width="736" height="180" alt="image" src="https://github.com/user-attachments/assets/cbe68334-1ff4-489e-bb43-ec944264491c" />

---

## **Step 7: Script Execution and Output**

**Run the script:**
```bash
sudo ./create_users.sh
```

**Output:**

<img width="537" height="287" alt="image" src="https://github.com/user-attachments/assets/239b52b4-43f4-4951-8492-9b50433920fc" />

---

## **Summary**

This automation project demonstrates the ability to:
- Use **Bash scripting** to streamline repetitive administrative tasks.  
- Validate **root privileges** and required input files for secure execution.  
- Create users, assign default passwords, and enforce **password resets** automatically.  
- Log all actions to ensure transparency and traceability.  
- Verify system changes through **user existence**, **home directory**, and **password expiration** checks.  

By completing this project, I gained hands-on experience in **file processing**, **text stream handling**, **permission management**, and **error control**, all of which are foundational skills for **Linux system administration**.

---

## **Tools & References**
- [Linux Beginners Cheat Sheet](https://ubuntu.com/tutorials/command-line-for-beginners#1-overview)  
- `useradd`, `chpasswd`, `passwd`, `tee`, and `chage` Linux utilities  
- [GNU Bash Manual](https://www.gnu.org/software/bash/manual/bash.html)  
- [File Permissions and Ownership](https://wiki.archlinux.org/title/File_permissions_and_attributes)
