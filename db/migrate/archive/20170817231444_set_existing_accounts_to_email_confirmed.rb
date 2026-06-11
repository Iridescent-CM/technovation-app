class SetExistingAccountsToEmailConfirmed < ActiveRecord::Migration[5.1]
  def up
    ActiveRecord::Base.connection.execute(
      "UPDATE accounts
       SET email_confirmed_at = '#{Time.current}'
       WHERE email_confirmed_at IS NULL"
    )

    $stdout.puts("#{Account.confirmed_email.count} confirmed accounts")
    $stdout.puts("(#{Account.count} total accounts)")
  end

  def down
    ActiveRecord::Base.connection.execute(
      "UPDATE accounts
       SET email_confirmed_at = NULL
       WHERE email_confirmed_at IS NOT NULL"
    )

    $stdout.puts("#{Account.unconfirmed_email.count} unconfirmed accounts")
    $stdout.puts("(#{Account.count} total accounts)")
  end
end
