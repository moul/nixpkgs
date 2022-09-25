package tools

import (
	// binary deps
	_ "berty.tech/berty/v2/go/cmd/berty-doctor"
	_ "github.com/cespare/prettybench"
	_ "github.com/daixiang0/gci/pkg/gci"
	_ "github.com/gfanton/loon"
	_ "github.com/gnolang/gno/cmd/gnokey"
	_ "github.com/goreleaser/goreleaser/pkg/build"
	_ "github.com/maruel/panicparse/v2/stack"
	_ "golang.org/x/tools/cover"
	_ "honnef.co/go/tools/go/loader"
	_ "moul.io/adapterkit"
	_ "moul.io/assh/v2"
	_ "moul.io/moulsay"
	_ "moul.io/prefix"
	_ "moul.io/retry"
	_ "moul.io/sshportal"
	_ "moul.io/testman"
	_ "pathwar.land/pathwar/v2/go/cmd/pathwar"

	// TODO
	// _ "moul.io/makerinbox"
	// _ "moul.io/anonuuid"
	// _ "moul.io/repoman"
	// _ "moul.io/web3man"

	// deps of deps
	_ "github.com/goreleaser/goreleaser/internal/client"
)
