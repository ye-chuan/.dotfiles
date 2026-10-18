require("diagram").setup({
    integrations = {
        require("diagram.integrations.markdown"),
        require("diagram.integrations.neorg"),
    },
    renderer_options = {
        mermaid = {
            background = "transparent",
            theme = "redux-dark-color",
            scale = 3,
        },
        plantuml = {
            charset = "utf-8",
        },
        d2 = {
            theme_id = 1,
        },
        gnuplot = {
            theme = "dark",
            size = "800,600",
        },
    },
})
