try:
    from config import branch_configuration
except:
    branch_configuration = {}

if "DEPLOY_CONSOLE" in branch_configuration:
    print("Deploy console %s" % branch_configuration['DEPLOY_CONSOLE'])
else:
    print("No Deploy console")

if 'UNIT_TESTS' in branch_configuration:
    for ut in branch_configuration['UNIT_TESTS']:
        print("Executing %s" % ut )
else:
    print("No unit tests")
