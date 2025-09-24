package resolver

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strings"
)

type WorkspacesSpec struct {
	Patterns []string
}

func (p *WorkspacesSpec) NormalizePatterns() error {
	normalized := make([]string, 0, len(p.Patterns))
	for _, pth := range p.Patterns {
		str := strings.TrimSpace(pth)
		if str != "" {
			normalized = append(normalized, str)
		}
	}
	p.Patterns = normalized

	if len(p.Patterns) == 0 {
		return fmt.Errorf("no workspaces defined")
	}

	return nil
}

func (p *WorkspacesSpec) UnmarshalJSON(data []byte) error {
	*p = WorkspacesSpec{}
	data = bytes.TrimSpace(data)

	if len(data) == 0 {
		return fmt.Errorf("invalid 'workspaces' format")
	}

	switch data[0] {
	case '[':
		var arr []string
		if err := json.Unmarshal(data, &arr); err != nil {
			return fmt.Errorf("failed to parse workspaces array: %w", err)
		}

		p.Patterns = arr
		err := p.NormalizePatterns()

		if err != nil {
			return err
		}

		return nil

	case '{':
		var obj struct {
			Packages []string `json:"packages"`
		}

		if err := json.Unmarshal(data, &obj); err != nil {
			return fmt.Errorf("failed to parse workspaces object: %w", err)
		}

		if obj.Packages == nil {
			return fmt.Errorf(`workspaces object must contain "packages"`)
		}

		p.Patterns = obj.Packages

		err := p.NormalizePatterns()

		if err != nil {
			return err
		}

		return nil

	default:
		return fmt.Errorf("invalid 'workspaces' format")
	}
}
