GO ?= go

install:
	$(GO) mod tidy
	$(GO) mod download
	$(GO) install github.com/maruel/panicparse/v2/cmd/pp
	$(GO) install golang.org/x/tools/cmd/goimports
	$(GO) install github.com/goreleaser/goreleaser
	$(GO) install github.com/daixiang0/gci
	$(GO) install honnef.co/go/tools/staticcheck

clean:
	rm -f $(GOBIN)/pp
