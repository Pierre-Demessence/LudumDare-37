set -x
lime build html5
cd ./export/html5/bin/
zip -r build.zip .
mv build.zip ../../../