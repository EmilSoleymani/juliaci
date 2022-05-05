module linter
using StaticLint, SymbolServer
export f, rootfile
# Where the SymbolServer cache files are stored. This can be any dir, the default is ".../SymbolServer/store" where ever that is. (Mine is set to the cache used by vscode)
const sscachedir = "/Users/emilsoleymani/Documents/SummerProject/JuliaContinuousIntegration/juliaci/.SymbolServer/store"
# Directory of the environment you want to load, this must have a Manifest.toml file. 
const envdir = "/Users/emilsoleymani/.julia/environments/v1.7/" 

# This is the 'root' file of the project. All other files will (hopefully!) be loaded subsequently through analysis of calls to `include`.
rootfile = "/home/zac/.julia/dev/StaticLint/src/StaticLint.jl" 

function f(rootfile)
    # This will hold the files of the loaded project
    server = StaticLint.FileServer(); 

    # Get symbols from all packages in the environment (this may take a while if sscachedir is new/empty)
    _,server.symbolserver = SymbolServer.getstore(SymbolServerInstance("", sscachedir), envdir)
    
    # Some internal fiddling to make connect references between packages within the environment.
    server.symbol_extends = SymbolServer.collect_extended_methods(server.symbolserver)

    # Loads and parses the file
    f = StaticLint.loadfile(server, rootfile)

    # StaticLint's main run- finding variables, scopes, etc.
    StaticLint.scopepass(f)

    # Run lint checks.
    hints = Dict()
    slopts = StaticLint.LintOptions(:)
    for (path, file) in server.files
        StaticLint.check_all(file.cst, slopts, server)
        hints[path] = StaticLint.collect_hints(file.cst, server)
    end
    for (p, hs) in hints
        println(p)
        for (offset, x) in hs
            if StaticLint.haserror(x) && StaticLint.errorof(x) isa StaticLint.LintCodes
                println("  ", StaticLint.LintCodeDescriptions[StaticLint.errorof(x)], " at ", offset)
            else
                # missing reference
                println("  Missing reference for `$(StaticLint.CSTParser.valof(x))` at ", offset)
            end
        end
    end
end

end # module