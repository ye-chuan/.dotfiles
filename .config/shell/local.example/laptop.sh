# Battery
alias batconserve='echo 1 | sudo tee "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"'
alias batnoconserve='echo 0 | sudo tee "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"'
