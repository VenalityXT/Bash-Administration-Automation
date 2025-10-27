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

Before performing user operations, the script checks two essential conditions and ensures the `Users.txt` file is properly created and available in the same directory as the script.

### **Creating the Input File**

First, generate a text file containing all usernames to automate account creation.  
Use the following command to create the file and populate it with multiple usernames, each on a new line:
```bash
echo -e "RusselAKADusty\npancake92\nbluejellyroll\ncyberjon\nariD\nMvri\nMunbuni" > Users.txt
```
**Explanation:**
- **`echo -e`** interprets escape sequences like `\n` to insert newlines.  
- **`>`** writes output to a file (creating it if it doesn’t exist).  
- Each line represents a unique username that will be processed by the script.  

You can verify that the file exists and contains the correct entries using:
```bash
cat Users.txt
```
**Output:**

<img width="908" height="231" alt="image" src="https://github.com/user-attachments/assets/1598de01-742f-4863-97c5-cf8311b2ef12" />

---

### **Verifying Script Preconditions**

After confirming the file exists, the script automatically checks that it’s running with **root privileges** and that the user file is found before continuing.

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
**Expanded Explanation:**

This part of the script ensures that the environment is properly set up before any user accounts are created. It checks that the script is being run with administrative (root) privileges and that the input file containing usernames actually exists. Let’s break it down line by line.
```bash
if [ "$EUID" -ne 0 ];
```
is checking:  
> “Is the current user’s effective ID *not equal to 0*?”  
If that’s true, the script knows you’re not root and stops execution.

---

#### `-ne` (Not Equal)
- `-ne` is a **numeric comparison operator** in Bash that means “not equal to.”  
- It’s part of Bash’s test syntax used inside `[ ]` brackets.  
- Example comparisons:
  - `[ 3 -eq 3 ]` → true (equal)
  - `[ 3 -ne 5 ]` → true (not equal)
- In this case, `[ "$EUID" -ne 0 ]` means “if the user ID is not 0.”

---

#### `exit 13/66`
- The `exit` command stops the script immediately and returns a code to the system.  
- Exit codes tell the system *why* the script stopped.  
- `13` and `66` are a standard code for **Permission Denied/File not found** respectfully, used here to indicate that the script failed because it wasn’t run with root privileges or that the file referenced was not in the specified directory.  
- You can see the last exit code in any terminal with:
```bash
echo $?
```
---

#### `[ ! -f "$USER_FILE" ]`
This condition checks if the input file (`Users.txt`) **does not exist**.

Let’s break that down:
- `-f` tests whether a file exists and is a **regular file**.  
- `!` negates the condition, turning “file exists” into “file does not exist.”  
- `$USER_FILE` is the variable that holds the path to your input file.  

So `[ ! -f "$USER_FILE" ]` means:  
> “If the file specified by `$USER_FILE` does not exist, then do the following.”

If that condition is true, the script prints an error and exits with code `44`.

---

#### `else`
If both checks pass (you’re root and the file exists), the script executes the `else` block:
```bash
echo "Starting user creation process..."
echo "---------------------------------"
```
This confirms the setup is valid and that the automation can safely continue.

---

#### Summary

| Condition | Purpose | Outcome if True | Exit Code |
|------------|----------|------------------|------------|
| `[ "$EUID" -ne 0 ]` | Check if user is not root | Prints error and stops | `13` |
| `[ ! -f "$USER_FILE" ]` | Check if `Users.txt` is missing | Prints error and stops | `44` |
| `else` | Both checks passed | Starts the user creation process | — |

In plain English:
> “If you’re not root, stop with a permission error.  
> If the username file doesn’t exist, stop with a file error.  
> Otherwise, start creating users safely.”

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

## **Step 6: Script Execution and Output**

**Run the script:**
```bash
sudo ./create_users.sh
```

**Output:**

<img width="537" height="287" alt="image" src="https://github.com/user-attachments/assets/239b52b4-43f4-4951-8492-9b50433920fc" />

---

## **Step 7: Verify Results**

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

<img width="775" height="198" alt="image" src="https://github.com/user-attachments/assets/007e3ea3-8990-456d-966d-bb52acfd9937" />


Logging on for the first time:

<img width="723" height="211" alt="image" src="https://github.com/user-attachments/assets/c5b2f7ae-009f-48dc-8b39-d676e1dd14a7" />

---

## **Summary**

This automation project demonstrates the ability to:
- Use **Bash scripting** to streamline repetitive administrative tasks.  
- Validate **root privileges** and required input files for secure execution.  
- Create users, assign default passwords, and enforce **password resets** automatically.  
- Log all actions to ensure transparency and traceability.  
- Verify system changes through **user existence**, **home directory**, and **password expiration** checks.  

By completing this project, I gained hands-on experience in **file processing**, **text stream handling**, **permission management**, and **error control**, all of which are foundational skills for **Linux system administration**.
