#!/usr/bin/env php7.2
<?PHP
/**
 * Small script for replacing the separator in a line of CSV.
 * The script takes a minimum of one and a maximum of three arguments.
 * - The first argument represents the string to handle.
 * - The second argument represents the original separator.
 * - The third argument represents the new separator.
 *
 * @author Joshua Ramon Enslin
 */

// Ensure some empty lines are printed after output.
register_shutdown_function(function() {
    echo PHP_EOL;
});

/*
 * Parse input parameters
 */
$argumentCount = count($argv);
if ($argumentCount === 1 || count($argv) > 4) { // Prevent
    echo "This script takes exactly one to three arguments.";
    exit;
}

if (!empty($argv[2])) {
    $oldSeparator = $argv[2];
}
else $oldSeparator = " "; // Default separator (old) is a whitespace.

if (!empty($argv[3])) {
    $newSeparator = $argv[3];
}
else $newSeparator = "|"; // Default separator (new) is a whitespace.

// Improving the input string
$input = $argv[1];      // Read the input string.
$input = trim($input);  // Remove unwanted characters from front and end.

while (strpos($input, "  ") !== false) { // Remove double whitespaces.
    $input = str_replace("  ", " ", $input);
}

// If the string has changed, let the user now.
if ($input !== $argv[1]) {
    echo "Sanitized input string from '{$argv[1]}' to '{$input}'" . PHP_EOL;
}

// Split the string
$inputSplit = explode($oldSeparator, $input);

// Printing output
echo "The input string split re-joined:" . PHP_EOL;
echo implode($newSeparator, $inputSplit);

