install:
	go mod tidy
	go mod download
	go install github.com/maruel/panicparse/v2/cmd/pp
	go install golang.org/x/tools/cmd/goimports
	go install github.com/goreleaser/goreleaser
	go install github.com/daixiang0/gci

clean:
	rm -f $(GOBIN)/pp
