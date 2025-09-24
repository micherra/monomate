package resolver

import (
	"strings"
)

type PackageManager struct {
	Manager Manager
	Version string
	Raw     string // e.g. "pnpm@8.6.0"
}

type Manager string

const (
	ManagerBun     Manager = "bun"
	ManagerPNPM    Manager = "pnpm"
	ManagerYarn    Manager = "yarn"
	ManagerNPM     Manager = "npm"
	ManagerUnknown Manager = ""
)

func (pm PackageManager) ParsePackageManager(packageManager string) PackageManager {
	packageManager = strings.TrimSpace(packageManager)

	parts := strings.SplitN(packageManager, "@", 2)
	managerPart := parts[0]

	var manager Manager
	switch managerPart {
	case "bun":
		manager = ManagerBun
	case "pnpm":
		manager = ManagerPNPM
	case "yarn":
		manager = ManagerYarn
	case "npm":
		manager = ManagerNPM
	default:
		manager = ManagerUnknown
	}

	var version string
	if len(parts) < 2 {
		version = ""
	} else {
		version = strings.TrimSpace(version)
	}

	return PackageManager{
		Manager: manager,
		Version: version,
		Raw:     packageManager,
	}
}

func (pm PackageManager) String() string {
	if pm.Manager == ManagerUnknown {
		return "unknown"
	}
	return pm.Raw
}
