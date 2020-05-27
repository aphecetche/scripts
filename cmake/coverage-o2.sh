# example of upload to codecov.io
# the commit hash must be the full one (not the abbrev)

#./codecov-uploader -f coverage.info -R /Users/laurent/alice/cmake/O2 -C 5e494e56c54d9adbe445eb81556af9811559a8ad -B cmake-migration -t 7256e1ab-123a-4b4e-a8da-f6c22aa6a38b

./codecov-uploader -f /Users/laurent/tmp/build/O2/alice-dev-coverage/coverage.info -R /Users/laurent/alice/dev/O2 -C 1646cd83137ea51e581f6634848b7f4f8a5ad153 -B mch-new-digit-time -t 7256e1ab-123a-4b4e-a8da-f6c22aa6a38b
