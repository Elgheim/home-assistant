# Custom Cards

This directory contains custom Lovelace cards for Home Assistant.

## Creating a New Card

1. Create a new directory for your card: `mkdir my-card`
2. Add the main card file: `my-card.js` or `my-card.ts`
3. Optionally add `package.json` for dependencies and build scripts
4. Include `card-config.js` for Lovelace UI editor support

## Example Card Structure

```
my-card/
├── my-card.js          # Main card implementation
├── card-config.js      # UI editor configuration
├── package.json        # Dependencies and scripts
└── README.md          # Card documentation
```