package resolver

type Workspace struct {
	Name    string            // e.g. "@tinyverse/core"
	Path    string            // absolute dir path containing package.json
	Scripts map[string]string // from package.json "scripts"
}
