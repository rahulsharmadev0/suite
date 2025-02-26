#!/bin/bash

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOL'
#!/bin/bash
bash ./scripts/pre-commit-dart-fix.sh
EOL

# Make the hook executable
chmod +x .git/hooks/pre-commit

echo "Git pre-commit hook has been set up successfully!"
