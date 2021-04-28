GO ?= go

install:
	$(GO) mod tidy
	$(GO) mod download
	$(GO) install github.com/maruel/panicparse/v2/cmd/pp
	$(GO) install golang.org/x/tools/cmd/goimports
	$(GO) install github.com/goreleaser/goreleaser
	$(GO) install github.com/daixiang0/gci
	$(GO) install honnef.co/go/tools/staticcheck
	$(GO) install moul.io/moulsay
	$(GO) install moul.io/prefix/cmd/prefix
	$(GO) install moul.io/retry
	$(GO) install github.com/tweag/gomod2nix

clean:
	rm -f $(GOBIN)/pp

gomod2nix:
	gomod2nix
