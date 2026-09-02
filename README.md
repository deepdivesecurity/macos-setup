# MacOS Setup

## About the Project
This MacOS setup project is to provide a generalized, standard, repeatable way of setting up MacOS apps and packages.

## Getting Started

### Prerequisites
- A Mac device with MacOS

### Installation/Usage
1. Clone the repo
   ```sh
   git clone https://github.com/deepdivesecurity/macos-setup.git
   ```
2. CD into the cloned directory from your terminal
   ```sh
   cd macos-setup
   ```
3. Create a `.env` file at the root of the project with the following format: 
   ```sh
   GIT_NAME="YOUR_GIT_NAME"
   GIT_EMAIL="YOUR_GIT_EMAIL"
   ```
4. Run the setup script to install configure MacOS, install Homebrew and the applicable brews/casks, and configure Git globals
   ```
   ./setup.sh
   ```

## Roadmap

- [ ] Add an open box Mac report that checks for issues like number of cycles, battery level, etc.

See the [open issues](https://github.com/deepdivesecurity/macos-setup/issues) for a complete list of proposed features and known issues.

## Additional Documentation/Resources
- [Homebrew](https://brew.sh/)
- [Brave Policies](https://support.brave.app/hc/en-us/articles/360039248271-Group-Policy)

## License
All Rights Reserved.