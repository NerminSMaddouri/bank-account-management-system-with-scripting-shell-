#!/bin/bash
# bank_manager: manually enter credits/debits and check account history
math(){
	echo "scale=2; $1 $2 $3" | bc     #shortcut to bc
}
accounts(){                         #make sure all files exist
	touch statement.txt
	touch cb.txt
	touch sb.txt
	touch bb.txt
	checkingBalance=`cat cb.txt`      #get balances
	savingsBalance=`cat sb.txt`
	businessBalance=`cat bb.txt`
}
get_args(){
  #read the user's inputs
	echo "Entrez le type de la transaction. [debit/credit]"
	read type
	echo "Entrez la valeur de la transaction . [x.xx]"
	read value
	echo "Entrez le destinataire ou l'expéditeur de la transaxction."
	read other_party
	echo "Entrez le compte pour effectuer cette transaction. [vérification/épargne/affaires]"
	read account
	echo "entrez la date de la transaction.)"
	read date_of
	if [[ $date_of == "" ]] ; then
		date_of=$(date +%D)
	fi
}
	enterTransaction(){
   	if [[ $type == "credit" ]] ; then transaction_prefix="$value"  ; fi
	if [[ $type == "debit" ]] ; then transaction_prefix="$value"  ; fi
   	printf "Making transaction of $transaction_prefix\$$value to account \"$account\"" #display status
}
makeTransaction(){
	if [[ $type == "credit" ]] ; then                        #check if credit
		if [[ $account == "checking" ]] ; then                 #check what account and credit amount
			checkingBalance=`math $checkingBalance + $value`
		elif [[ $account == "savings" ]] ; then
			savingsBalance=`math $savingsBalance + $value`
		elif [[ $account == "business" ]] ; then
			businessBalance=`math $businessBalance + $value`
		fi
	elif [[ $type == "debit" ]] ; then                      #same thing but debit
		if [[ $account == "checking" ]] ; then
			checkingBalance=`math $checkingBalance - $value`
		elif [[ $account == "savings" ]] ; then
			savingsBalance=`math $savingsBalance - $value`
		elif [[ $account == "business" ]] ; then
			businessBalance=`math $businessBalance - $value`
		fi
	fi
	echo -e "\nTransaction to $account account finished. Logging transaction..."
	echo "vos soldes :"
	echo -e "vérification: \$$checkingBalance" #state balances
	echo -e "éparagne : \$$savingsBalance"
	echo -e "affaires : \$$businessBalance"

}
logTransaction(){
  #log the transaction
	echo "Transaction to $account account:" >> statement.txt 
	if [[ $type == "credit" ]] ; then echo "From: $other_party |" >> statement.txt; fi
	if [[ $type == "debit" ]] ; then echo "To: $other_party |" >> statement.txt; fi
	echo -n "$tpr\$$value" >> statement.txt
	echo "Completed on $date_of" >> statement.txt
	echo "" >> statement.txt
	echo $businessBalance > bb.txt
	echo $checkingBalance > cb.txt
	echo $savingsBalance > sb.txt
}
accounts
get_args
enterTransaction
makeTransaction
logTransaction 
