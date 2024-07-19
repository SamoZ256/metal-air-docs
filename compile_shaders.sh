function compileShaderForSystem {
    xcrun -sdk $2 metal -o shaders/$2/$1.ir -c shaders/$1.metal
    llvm-dis shaders/$2/$1.ir -o shaders/$2/$1.ll
}

function compileShader {
    compileShaderForSystem $1 "macosx"
    compileShaderForSystem $1 "iphoneos"
    compileShaderForSystem $1 "appletvos"
    compileShaderForSystem $1 "watchos"
}

compileShader "simple"
