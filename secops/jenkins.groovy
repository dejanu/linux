// Jenkins get credentials:



varr = '{HASH-value from credentials with inspectE=}'
println(hudson.util.Secret.decrypt(varr))
