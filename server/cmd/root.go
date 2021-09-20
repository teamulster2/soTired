/*
Copyright © 2021 AnnaGsell, carina-str, diehmlukas, mac641, treilik

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
*/
package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"

	homedir "github.com/mitchellh/go-homedir"
	"github.com/spf13/viper"
)

var cfgFile string

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "soti-server",
	Short: "server side backend of soTired apps",
	Long:  `server side backend for data management of soTired apps, e. g. for study management.`,
	// Uncomment the following line if your bare application
	// has an action associated with it:
	// Run: func(cmd *cobra.Command, args []string) { },
}

// exportCmd represents the command which handels the full database export to json
var exportCmd = &cobra.Command{
	Use:   "export",
	Short: "export full study data of database",
	Run:   exportDatabase,
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	cobra.CheckErr(rootCmd.Execute())
}

func init() {
	cobra.OnInitialize(initConfig)

	// Here you will define your flags and configuration settings.
	// Cobra supports persistent flags, which, if defined here,
	// will be global for your application.
	rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.sotiredserver.yaml)")
	exportCmd.Flags().String("db-path", "default.db", "the path to the database file")
	exportCmd.Flags().String("out-path", "default.json", "the path to the file where the json output should be writen to")
	exportCmd.Flags().Bool("verbose", false, "enable database verbosity")
	rootCmd.AddCommand(exportCmd)

	// Cobra also supports local flags, which will only run
	// when this action is called directly.
	rootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
	run.Flags().Uint16("port", 50000, "port to serve on")
	run.Flags().String("config-path", "default.db", "server config path to be used")
	rootCmd.AddCommand(run)
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	if cfgFile != "" {
		// Use config file from the flag.
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		home, err := homedir.Dir()
		cobra.CheckErr(err)

		// Search config in home directory with name ".sotiredserver" (without extension).
		viper.AddConfigPath(home)
		viper.SetConfigName(".sotiredserver")
	}

	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		fmt.Fprintln(os.Stderr, "Using config file:", viper.ConfigFileUsed())
	}
}

var run = &cobra.Command{
	Use:   "run",
	Short: "start server",
	Long:  `start http server listening on given port to send reports from the sotired app`,
	Run:   serveRun,
}
