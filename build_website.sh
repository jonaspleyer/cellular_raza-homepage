CR_FOLDER=./cellular_raza
CWD=$(pwd)

generate_docs() {
    TARGETS=(
        cellular_raza
        cellular_raza-building-blocks
        cellular_raza-concepts
        cellular_raza-core
    )

    # Make sure that cellular_raza is initialized and updated
    git submodule init
    git submodule update --recursive

    cd $CR_FOLDER
    cargo clean --doc

    for target in ${TARGETS[@]}; do
        cargo +nightly-2025-02-01 rustdoc \
            -p $target \
            --all-features --\
            --cfg docsrs\
            --theme $CWD/static/hextra.css \
            --default-theme hextra \
            --html-in-header $CWD/custom_navbar.html \
            --html-in-header $CWD/.docs-header.html
    done
    cd $CWD

    # Swap old for new folder
    rm -rf $CWD/static/docs
    cp -r $CR_FOLDER/target/doc $CWD/static/docs
}

build_website() {
    hugo -d public_html
}

movie() {
    # Generate the movie
    gource \
    -s .15 \
    --default-user-image static/JonasPleyer-circle.png \
    -1280x720 \
    --auto-skip-seconds .05 \
    --multi-sampling \
    --stop-at-end \
    --key \
    --highlight-users \
    --date-format "%d/%m/%y" \
    --hide mouse,filenames \
    --file-idle-time 0 \
    --max-files 0  \
    --background-colour 000000 \
    --font-size 25 \
    --output-framerate 60 \
    --disable-auto-rotate \
    --max-user-speed 30 \
    --dir-name-depth 1 \
    --highlight-dirs \
    --dir-name-position 1.0 \
    --file-filter "(cellular_raza-homepage|cellular_raza_book|cellular_raza-book|cellular_raza-benchmarks|benchmark_results)" \
    --output-ppm-stream - \
    cellular_raza \
    | ffmpeg -y -r 60 -f image2pipe -pix_fmt yuv420p -c:v h264 -y -vcodec ppm -i - -b 65536K output.mp4
    # Compress the movie
    ffmpeg -i output.mp4 -pix_fmt yuv420p -y cellular_raza-development-gource.mp4
    # Move it to the hompage folder
    mkdir -p static/internals/
    mv cellular_raza-development-gource.mp4 static/internals/
}

scc_table() {
    scc \
        --exclude-dir cellular_raza-homepage \
        --exclude-dir cellular_raza-benchmarks/benchmark_results \
        --exclude-dir target \
        --no-size \
        -f html-table \
        -s lines \
        -o static/internals/scc-table.html \
        cellular_raza
}

todo_table() {
    ./static/internals/todo-table-generate.sh > ./static/internals/todo-table.html
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo " -h --help        Display this help message"
    echo " -d --doc         Generate rust documentation"
    echo " -w --website     Build website"
    echo " -m --movie       Generate Movie of cellular_raza development"
    echo "    --scc         Create a scc table in ./static/internals/scc-table.html"
    echo "    --todo        Create a table of todos in the ./static/internals/todo-table.html"
    echo " -u --upload      Upload to server"
    echo " -a --all         Do a full build with upload. Same as -d -w -u --scc --todo"
}

upload() {
    cwd="$PWD"
    # This command can also be used to simply recursively copy all files
    # id does not filter duplicates and thus takes a long time
    # scp -r public_html celluld@www139.your-server.de:/

    sftp celluld@www139.your-server.de<<EOF
    put -R $cwd/public_html
    exit
EOF
    cd ..
}

handle_options() {
    while [ $# -gt 0 ]; do
        case $1 in
            -d | --doc)
                generate_docs
                ;;
            -w | --website)
                build_website
                ;;
            -u | --upload)
                upload
                ;;
            -m | --movie)
                movie
                ;;
            --scc)
                scc_table
                ;;
            --todo)
                todo_table
                ;;
            -a | --all)
                generate_docs
                build_website
                scc_table
                todo_table
                upload
                ;;
            -h | --help)
                usage
                ;;
            \?)
                usage
                ;;
        esac
        exit 0
    done
}

handle_options "$@"

