# Makefile
APP        ?= monomate
PKG        ?= github.com/micherra/monomate
BUILD_PKG  ?= $(PKG)/internal/buildinfo

# Auto-populated build metadata
VERSION    ?= $(shell git describe --tags --always --dirty)
COMMIT     ?= $(shell git rev-parse --short HEAD)
DATE       ?= $(shell date -u '+%Y-%m-%dT%H:%M:%SZ')

# Common ldflags
LDFLAGS := -s -w \
  -X '$(BUILD_PKG).Version=$(VERSION)' \
  -X '$(BUILD_PKG).Commit=$(COMMIT)' \
  -X '$(BUILD_PKG).BuildDate=$(DATE)'

# Cross-compile defaults (override from CLI if you want)
GOOS      ?= $(shell go env GOOS)
GOARCH    ?= $(shell go env GOARCH)

# Resolve where go install puts binaries
GOBIN_RESOLVED := $(shell go env GOBIN)
ifeq ($(strip $(GOBIN_RESOLVED)),)
  GOBIN_RESOLVED := $(shell go env GOPATH)/bin
endif

.PHONY: build install uninstall clean version

build:
	@echo "Building $(APP) $(VERSION) ($(COMMIT))..."
	GOOS=$(GOOS) GOARCH=$(GOARCH) CGO_ENABLED=0 \
		go build -trimpath -ldflags "$(LDFLAGS)" -o bin/$(APP) .

install:
	@echo "Installing $(APP) $(VERSION) ($(COMMIT))..."
	CGO_ENABLED=0 go install -trimpath -ldflags "$(LDFLAGS)" .

uninstall:
	@set -e; \
	TARGET="$(GOBIN_RESOLVED)/$(APP)"; \
	if [ -x "$$TARGET" ]; then \
	  echo "Removing $$TARGET"; rm -f "$$TARGET"; \
	else \
	  echo "No $(APP) found at $$TARGET (try: which $(APP))"; \
	fi

version:
	@echo "VERSION=$(VERSION)"
	@echo "COMMIT=$(COMMIT)"
	@echo "DATE=$(DATE)"

clean:
	rm -rf bin
	rm monomate
