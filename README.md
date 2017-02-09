# macOS Sierra Gnuradio with gnuradio-companion and all plugins, plus gr-forphor with osmocomSDR included
Install with the following command:
brew install gwt gnuradio grfosphor --no-sandbox --verbose --debug

Check for any errors, you may want to start with a *clean* /usr/local

Ping Kevin Finisterre at Department 13 for any issues with this gnuradio (macOS Sierra Only!) formula.

# Homebrew Core
Core formulae for the Homebrew package manager.

## Update Bug
If Homebrew was updated on Aug 10-11th 2016 and `brew update` always says `Already up-to-date.` you need to run:
```bash
cd "$(brew --repo)" && git fetch && git reset --hard origin/master && brew update
```

## How do I install these formulae?
Just `brew install <formula>`. This is the default tap for Homebrew and is installed by default.

## Troubleshooting
First, please run `brew update` (twice) and `brew doctor`.

Second, read the [Troubleshooting Checklist](http://docs.brew.sh/Troubleshooting.html).

**If you don’t read these it will take us far longer to help you with your problem.**

## Contributing
Read [CONTRIBUTING.md](/CONTRIBUTING.md).

Creating new formulae, updating existing ones, and fixing build issues is easier than you think!

Try `brew edit $FORMULA` and see how you fare.

## Documentation
`brew help`, `man brew`, [Homebrew/brew's README](https://github.com/Homebrew/brew#homebrew) or check [Homebrew's documentation](https://github.com/Homebrew/brew/tree/master/docs#readme).

## License
Code is under the [BSD 2 Clause (NetBSD) license](https://github.com/Homebrew/homebrew-core/blob/master/LICENSE.txt).
