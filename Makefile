# Clean the repo
clean:; forge clean

# Install the Modules
install:; forge install

# Update Dependencies
update:; forge update

# Builds
build:; forge clean && forge build --optimize --optimize-runs 1000000

# chmod scripts
scripts:; chmod +x ./scripts/*

# Tests
test :; forge clean && forge test --optimize --optimize-runs 1000000 -v

# Lints
lint:; prettier --write src/**/*.sol && prettier --write src/*.sol

# Generate Gas Snapshots
snap:; forge clean && forge snapshot --optimize --optimize-runs 1000000
