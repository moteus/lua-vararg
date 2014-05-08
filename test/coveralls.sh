cd $TRAVIS_BUILD_DIR

if [ $VARARG = "vararg" ]; then
  coveralls;
else
  cd test
  lua$LUA_SFX report_coverage.lua
  curl -v -H "Content-Type: multipart/related" --form "json_file=@luacov.report.json;type=application/json" https://coveralls.io/api/v1/jobs;
fi
