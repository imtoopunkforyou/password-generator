# Password Generator
Cryptographic password generator for the command line.

## Installation
1. Download the script:
```bash
curl -O https://raw.githubusercontent.com/imtoopunkforyou/password-generator/refs/heads/main/password-generator.sh
```

2. Make executable:
```bash
chmod +x password-generator.sh
```

## Usage
- Basic generation (12 characters with default charset):
```bash
./password-generator.sh --length 12
```

- Custom character set (ASCII letters and numbers):
```bash
./password-generator.sh --length 16 --charset "a-zA-Z0-9"
```

## Alias Setup
Add to your shell configuration (.bashrc/.zshrc):
```bash
alias genpass="/path/to/password-generator.sh --length"
```
Usage with alias:
```bash
genpass 14  # Generates 14-character password
```
```bash
genpass 8 --charset "A-Za-z"  # Letters only
```

## Command-line options
| Option          | Description                      | Required |
|-----------------|----------------------------------|----------|
| -l, --length    | Password length (4-64)           | No       |
| -c, --charset   | Custom tr-compatible pattern     | No       |
| -h, --help      | Show usage information           | No       |
