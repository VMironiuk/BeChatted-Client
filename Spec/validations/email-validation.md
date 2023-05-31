# Email Validation

## Consider the following rules

1. Presence of "@" symbol: The email address must contain the "@" symbol, which separates the local part
   (before the "@" symbol) from the domain part (after the "@" symbol).
2. Valid characters: Ensure that the email address contains only valid characters.
   Valid characters typically include letters (a-z, both uppercase and lowercase), digits (0-9), periods (.),
   underscores (_), hyphens (-), and the "@" symbol.
3. Local part rules:
    * It should not start or end with a period (.) or an underscore (_).
    * Consecutive periods (..) or underscores (__), or a period followed by an underscore (._) are not allowed.
    * The local part can contain a maximum of 64 characters.
4. Domain part rules:
    * It should contain at least one period (.) to separate domain levels (e.g., domain.com).
    * Each domain level should consist of letters, digits, or hyphens.
    * The domain part can have a maximum length of 255 characters.
5. Top-level domain (TLD) rules:
    * Ensure that the TLD is a valid and recognized domain extension (e.g., .com, .net, .org).
    * The TLD can have a maximum length of 63 characters.
6. Case sensitivity: Email addresses are typically case-insensitive, so consider converting the input to lowercase 
   before validation.
7. Avoid whitespace: Trim any leading or trailing whitespace from the input.