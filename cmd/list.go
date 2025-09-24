package cmd

import (
	"path/filepath"

	"github.com/micherra/monomate/internal/resolver"
	"github.com/spf13/cobra"
)

var listCmd = &cobra.Command{
	Use:   "list",
	Short: "List all workspaces in the monorepo",
	RunE: func(cmd *cobra.Command, args []string) error {
		// Resolve flags
		repo, _ := cmd.Flags().GetString("repo")

		// Discover monorepo
		r, err := resolver.New(repo)
		if err != nil {
			return err
		}

		monorepo, err := r.Discover()
		if err != nil {
			return err
		}

		// Print the monorepo details
		cmd.Printf("Monorepo Root: %s\n", monorepo.RootPath)
		cmd.Printf("Package Manager: %s\n\n", monorepo.Manager.String())
		cmd.Printf("Workspaces:\n")
		for _, pattern := range monorepo.Patterns {
			pattern, _ = filepath.Rel(monorepo.RootPath, pattern)
			cmd.Printf(" - %s\n", pattern)
		}
		cmd.Printf("\nTotal Workspaces: %d\n", len(monorepo.Patterns))
		return nil
	},
}

func init() {
	listCmd.Flags().StringP("repo", "r", ".", "Path to the monorepo root")
	rootCmd.AddCommand(listCmd)
}
