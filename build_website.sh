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

    cd cellular_raza
    cargo clean --doc

    for target in ${TARGETS[@]}; do
        cargo +nightly-2024-06-01 rustdoc \
            -p $target \
            --all-features --\
            --cfg docsrs\
            --theme ../static/hextra.css \
            --default-theme hextra \
            --html-in-header ../custom_navbar.html \
            --html-in-header ../.docs-header.html
    done
    cd ..

    # Swap old for new folder
    rm -rf static/docs
    cp -r cellular_raza/target/doc static/docs
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
                exit 0
                ;;
            -w | --website)
                build_website
                exit 0
                ;;
            -u | --upload)
                upload
                exit 0
                ;;
            -m | --movie)
                movie
                exit 0
                ;;
            --scc)
                scc_table
                exit 0
                ;;
            --todo)
                todo_table
                exit 0
                ;;
            -a | --all)
                generate_docs
                build_website
                scc_table
                todo_table
                upload
                exit 0
                ;;
            -h | --help)
                usage
                exit 0
                ;;
            \?)
                usage
                exit 1
                ;;
        esac
    done
}

handle_options "$@"

