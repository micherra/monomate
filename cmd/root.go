package cmd

import (
	"fmt"
	"os"

	"github.com/micherra/monomate/internal/buildinfo"
	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:          "monomate",
	Short:        "Monomate is your monorepo management buddy",
	Long:         `Operate on workspaces by name (add, remove, install, run) across Bun, pnpm, yarn, npm.`,
	Version:      buildinfo.Version,
	SilenceUsage: true,
	RunE: func(cmd *cobra.Command, args []string) error {
		return cmd.Help()
	},
}

func init() {
	rootCmd.SetVersionTemplate(fmt.Sprintf("{{.Name}} %s\n", buildinfo.String()))
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
