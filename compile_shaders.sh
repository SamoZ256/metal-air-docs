function compileShaderForSystem {
    xcrun -sdk $2 metal -O0 -Wno-unused-value -o shaders/$2/$1.ir -c shaders/$1.metal
    llvm-dis shaders/$2/$1.ir -o shaders/$2/$1.ll
}

function compileShader {
    compileShaderForSystem $1 "macosx"
    compileShaderForSystem $1 "iphoneos"
    compileShaderForSystem $1 "appletvos"
    compileShaderForSystem $1 "watchos"
}

mkdir -p shaders/macosx
mkdir -p shaders/iphoneos
mkdir -p shaders/appletvos
mkdir -p shaders/watchos

for file in shaders/*; do
    if [ -d $file ]; then
        continue
    fi
    if [ ${file: -6} != ".metal" ]; then
        continue
    fi
    filename="$(b=${file##*/}; echo ${b%.*})"
    compileShader $filename
done
