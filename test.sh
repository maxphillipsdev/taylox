#!/usr/bin/env bash
echo "==== Taylox acceptance tests ===="

echo "---- Building Taylox... ----"
bin_path=$(swift build --show-bin-path)

echo "---- Running tests... ----"
dart tool/bin/test.dart jlox --interpreter $bin_path/taylox
echo "==== Complete! ===="
