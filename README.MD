# AtomiCloud Home Manager 

Base Home Manager with default configuration for AtomiCloud

# Get Started

1. Setup Nix and Home Manager
    ```bash
    curl -L https://raw.githubusercontent.com/AtomiCloud/home-manager/main/scripts/setup.sh | sh
    ```

2. Change the directory to `~/.config/home-manager`
    ```bash
    cd ~/.config/home-manager
    ```

3. Edit your Profile, `profiles.nix` in the current folder

| Field | Description | Values |
| --- | --- | --- |
| `user`| Your machine's user. You can check this by running `echo $USER` ins your terminal | any |
| `email` | Your Github's email (must be the same) | any valid email |
| `gituser` | Your Github's user name | any valid username |
| `arch` | Your system's Architecture. | See [Operating System Enums](#operating-system-enums) |
| `kernel` | Your system's Kernel type. | See [Operating System Enums](#operating-system-enums) |

## Operating System Enums

| Operating System | Arch            | Kernel |
| ---------------- | ---------------- |------ |
| M1 MacBook       | `aarch64` | `darwin` |
| Intel MacBook    | `x86_64`  | `darwin` |
| Intel Linux      | `x86_64`   | `linux` |
| ARM Linux        | `aarch64`  | `linux` |


*If you are unsure of which type of computer or machine you are using, you can
run manual commands to check:*

#### Checking Arch

```bash
uname -m
```

| Command Result | Arch |
| --- | --- |
| `arm64` | `aarch64` |
| `x64_64` | `x86_64` |

#### Checking Kernel

```bash
uname -s
```

| Command Result | Kernel |
| --- | --- |
| `Darwin` | `darwin` |
| `Linux` | `linux` |

