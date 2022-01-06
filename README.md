# password_vault_mobile

A simple flutter app for android, focused on locally storing encrypted data.

## Getting Started

Password Vault Mobile provides a way to encrypt and store your sensitive data (accounts credentials and other information) on your mobile device.
User chooses a master password, which is used to encrypt all of his data.
Master password hash is generated through PBKDF2-HMAC-SHA512 and AES-128 is used for  user's data manipulation.
