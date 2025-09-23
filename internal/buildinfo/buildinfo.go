package buildinfo

var (
	Version   = "dev"
	Commit    = "none"
	BuildDate = "unknown"
)

func String() string {
	return Version + " (commit: " + Commit + ", built at: " + BuildDate + ")"
}
