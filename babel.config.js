module.exports = {
  presets: ['module:metro-react-native-babel-preset'],
  plugins: [
    [
      "module-resolver",
      {
        "alias": {
          "@features": [
            "./src/Features"
          ],
          "@components": [
            "./src/Components"
          ],
          "@bridges": [
            "./src/Bridges"
          ]
        }
      }
    ]
  ]
};
