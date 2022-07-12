package tools

import (
	// binary deps
	_ "github.com/cespare/prettybench"
	_ "github.com/daixiang0/gci/pkg/gci"
	_ "github.com/gfanton/loon"
	_ "github.com/gnolang/gno/cmd/gnokey"
	_ "github.com/goreleaser/goreleaser/pkg/build"
	_ "github.com/maruel/panicparse/v2/stack"
	_ "golang.org/x/tools/cover"
	_ "honnef.co/go/tools/go/loader"
	_ "moul.io/moulsay"
	_ "moul.io/prefix"
	_ "moul.io/retry"

	// deps of deps
	_ "github.com/goreleaser/goreleaser/internal/client"
)
