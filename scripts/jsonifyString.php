#!/usr/bin/env php7.2
<?PHP
/**
 * Small script for splitting a string into an array and JSON-encoding the array
 * after.
 * The script takes a minimum of one and a maximum of two arguments.
 * - The first argument represents the string to split.
 * - The second argument represents the separator.
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
if ($argumentCount === 1 || count($argv) > 3) { // Prevent
    echo "This script takes exactly one or two arguments.";
    exit;
}

if (!empty($argv[2])) {
    $separator = $argv[2];
}
else $separator = " "; // Default separator is a whitespace.

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
$inputSplit = explode($separator, $input);

// Printing output
echo "The input string split and jsonified:" . PHP_EOL;
echo json_encode($inputSplit, JSON_UNESCAPED_UNICODE);

