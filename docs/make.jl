using Documenter
using juliaci

makedocs(
    sitename = "juliaci",
    format = Documenter.HTML(),
    modules = [juliaci]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/EmilSoleymani/juliaci.git"
)
