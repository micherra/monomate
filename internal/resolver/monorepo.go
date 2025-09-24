package resolver

type Monorepo struct {
	RootPath string // absolute path to monorepo root
	//Workspaces   []Workspace          // discovered workspaces
	//WorkspaceMap map[string]Workspace // quick lookup by Name
	Patterns []string       // the workspace globs we expanded
	Manager  PackageManager // detected from root "packageManager"
}
