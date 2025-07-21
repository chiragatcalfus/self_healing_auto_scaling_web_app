cd ./terraform
terraform init
terraform apply -auto-approve
terraform output -json > tf_output.json
# Define output inventory path
inventory_file="../ansible/inventory.ini"

# Start fresh
echo "[master]" > "$inventory_file"

# Extract master IP
jq -r '.master.value // empty' tf_output.json >> "$inventory_file"

echo "" >> "$inventory_file"
echo "[slaves]" >> "$inventory_file"

jq -r '.slave1.value // empty' tf_output.json >> "$inventory_file"
jq -r '.slave2.value // empty' tf_output.json >> "$inventory_file"


# # Dynamically extract slave IPs in order (assumes keys are slave-1, slave-2, ...)
# jq -r 'to_entries[] | select(.key | test("^slave-[0-9]+$")) | [.key, .value.value] | @tsv' tf_output.json \
#     | sort -V \
#     | cut -f2 \
#     >> "$inventory_file"

# Append Ansible variables
cat <<EOF >> "$inventory_file"

[all:vars]
ansible_user=ubuntu
ansible_become=true
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_private_key_file=~/.ssh/ec2-testing-key.pem
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o IdentitiesOnly=yes'
EOF

echo "Ansible inventory generated at $inventory_file"

sleep 10
cd ../ansible
ansible-playbook -i inventory.ini playbook.yaml 


cd ../ansible_deployment
ansible-playbook -i ../ansible/inventory.ini site.yaml --vault-password-file ../.vault_pass.txt