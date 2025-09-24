package resolver

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

type Resolver struct {
	root string
}

func New(root string) (*Resolver, error) {
	if root == "" {
		return nil, fmt.Errorf("root path cannot be empty")
	}

	info, err := os.Stat(root)
	if err != nil {
		return nil, fmt.Errorf("failed to stat root path: %w", err)
	}
	if !info.IsDir() {
		return nil, fmt.Errorf("root path is not a directory: %s", root)
	}

	absRoot, err := filepath.Abs(root)
	if err != nil {
		return nil, fmt.Errorf("failed to get absolute path of root: %w", err)
	}

	return &Resolver{root: absRoot}, nil
}

func (r *Resolver) Discover() (*Monorepo, error) {
	pkgJSONPath := filepath.Join(r.root, "package.json")
	data, err := os.ReadFile(pkgJSONPath)
	if err != nil {
		return nil, fmt.Errorf("failed to read package.json: %w", err)
	}

	var rootPkg RootPkg
	if err := json.Unmarshal(data, &rootPkg); err != nil {
		return nil, fmt.Errorf("failed to parse package.json: %w", err)
	}

	if len(rootPkg.Workspaces.Patterns) == 0 {
		return nil, fmt.Errorf("no workspaces defined in package.json")
	}

	directories, err := WorkspaceGlobResolver(r.root, rootPkg.Workspaces.Patterns)

	if err != nil {
		return nil, fmt.Errorf("failed to resolve workspace globs: %w", err)
	}

	pm := PackageManager{Manager: ManagerUnknown, Version: "", Raw: ""}

	if rootPkg.PackageManager != nil {
		pm = pm.ParsePackageManager(*rootPkg.PackageManager)
	}

	return &Monorepo{
		RootPath: r.root,
		Patterns: directories,
		Manager:  pm,
	}, nil
}

func WorkspaceGlobResolver(root string, workspaceGlobs []string) ([]string, error) {
	var directories []string
	for _, pattern := range workspaceGlobs {
		matches, err := filepath.Glob(filepath.Join(root, pattern))
		if err != nil {
			return nil, fmt.Errorf("failed to glob pattern %s: %w", pattern, err)
		}
		for _, match := range matches {
			info, err := os.Stat(match)
			if err != nil {
				return nil, fmt.Errorf("failed to stat path %s: %w", match, err)
			}
			if info.IsDir() {
				pkgJSONPath := filepath.Join(match, "package.json")
				if _, err := os.Stat(pkgJSONPath); err == nil {
					directories = append(directories, match)
				}
			}
		}
	}

	return directories, nil
}
