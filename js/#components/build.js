require("esbuild").build({
    entryPoints: [
        "js/#components/index.js",
    ],
    outfile: "js/blog_components.min.js",
    bundle: true,
    minify: true,
    plugins: [require("esbuild-vue")()],
    target: "es2015",
    external: []
});