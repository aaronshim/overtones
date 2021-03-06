var HtmlWebpackPlugin = require('html-webpack-plugin');
var path = require('path');

module.exports = {
    entry: './src/index.js',
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'app.js'
    },

    // Replace our index.html
    plugins: [ new HtmlWebpackPlugin({
        title: 'Overtones',
        template: './src/index.ejs',
        hash: true // browser cache busting
    }) ],

    module: {
        rules: [
            {
                // All our Elm code, particularly Main.elm
                test: /\.elm$/,
                exclude: [/elm_stuff/, /node_modules/, /src\/css\/.+\.elm$/],
                use: [
                        {
                            loader: 'uglify-loader',
                            options: {}
                        },
                        {
                            loader: 'elm-webpack-loader',
                            options: {}
                        },
                ]
            },
            {
                // We need this for Milligram and normalize.css and fonts
                test: /\.css$/,
                use: [
                    'style-loader',
                    { loader:'css-loader', options: { minimize: true, sourceMap: true } },
                ]
            },
            {
                // Special rule for compiling our elm-css and then passing it to the css-loader!style-loader
                test: /src\/css\/Stylesheets\.elm$/,
                use: [
                    'style-loader',
                    { loader:'css-loader', options: { minimize: true } },
                    'elm-css-webpack-loader',
                ]
            }
        ]
    },

    // Inline mode
    devServer: {
        contentBase: path.join(__dirname, 'dist'),
        inline: true,
        compress: true
    }
}