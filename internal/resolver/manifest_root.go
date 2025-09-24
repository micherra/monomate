package resolver

type RootPkg struct {
	PackageManager *string        `json:"packageManager"`
	Workspaces     WorkspacesSpec `json:"workspaces"`
}
