#r "..\\packages\\FSharp.Charting.0.90.10\\lib\\net40\\FSharp.Charting.dll"

open System
open System.Globalization
open FSharp.Charting

type Description =
      Transfer of string 
    | DirectDebit of string
    | Groceries of string
    | OrganicGroceries of string
    | HemaAndStuff of string
    | Salary of string
    | Rent of string
    | Clothes of string
    | PublicTransport of string
    | Outing of string
    | Cash of string
    | Savings of string
    | Health of string
    | Sport of string
    | CreditCard of string
    | Others of string
    | Holidays of string

type Transaction = { 
    id : int;
    currency : string;
    date : DateTime;
    before : decimal;
    after : decimal;
    dateAgain : DateTime;
    transaction : decimal;
    description : Description
}

let stringToDate d = System.DateTime.ParseExact(d, "yyyymmdd", null)
let stringToDecimal (s:string) = s.Replace(",", ".") |> decimal

// used to groupBy Description types
let getTag (a:Transaction) = 
  let (uc,_) = Microsoft.FSharp.Reflection.FSharpValue.GetUnionFields(a.description, typeof<Description>)
  uc.Name

let (|RegexContains|_|) pattern input = 
    let matches = System.Text.RegularExpressions.Regex.Matches(input, pattern, Text.RegularExpressions.RegexOptions.IgnoreCase)
    if matches.Count > 0 then Some input
    else None

let getDescription desc = 
    match desc with
     | RegexContains "EkoPlaza" desc -> OrganicGroceries(desc.Substring(33, 20))
     | RegexContains "Biomarkt" desc -> OrganicGroceries(desc.Substring(33, 20))
     | RegexContains "Marqt" desc -> OrganicGroceries(desc.Substring(33, 20))
     | RegexContains "Estafette Amsterdam" desc -> OrganicGroceries(desc.Substring(33, 20))

     | RegexContains "Stach BV" desc -> Groceries(desc.Substring(33, 20))
     | RegexContains "ALBERT HEIJN" desc -> Groceries(desc.Substring(33, 20))
     | RegexContains "Slagerij" desc -> Groceries(desc.Substring(33, 20))
     | RegexContains "SUPERMARKT 'DE MAROK" desc -> Groceries(desc.Substring(33, 20))
     | RegexContains "Toko Dun Yong" desc -> Groceries(desc.Substring(33, 20))
     | RegexContains "Sodexo" desc -> Groceries(desc.Substring(33, 20)) // lunch at work
     | RegexContains "ABNANL2A/NAME/VM PIRE" desc -> Groceries(desc.Substring(33, 20)) // lunch at work
     | RegexContains "White label coffee" desc -> Groceries(desc.Substring(33, 20))
     | RegexContains "VB Vijzelstraat" desc -> Groceries desc
     | RegexContains "VB Elandsgracht" desc -> Groceries desc

     | RegexContains "HEMA" desc -> HemaAndStuff(desc.Substring(33, 20))
     | RegexContains "Kruidvat" desc -> HemaAndStuff(desc.Substring(33, 20))
     | RegexContains "Chris Bloemsierkunst" desc -> HemaAndStuff(desc.Substring(33, 20))
     | RegexContains "VIVANT MIKO AMSTERDA" desc -> HemaAndStuff desc
     | RegexContains "Media Markt Arena BV" desc -> HemaAndStuff desc
     | RegexContains "MM Amsterdam Centrum" desc -> HemaAndStuff desc

     | RegexContains "Travix Nederland BV" decs -> Salary desc
     | RegexContains "/Booking.com Customer Service Center" desc -> Salary desc

     | RegexContains "RABONL2U/NAME/Tom/REMI" desc -> Rent desc

     | RegexContains "Outlet A'dam AMSTERDAM Z" desc -> Clothes desc
     | RegexContains "H&M" desc -> Clothes desc
     | RegexContains "Wild Romance AMSTERDAM" desc -> Clothes desc

     | RegexContains "GVB" desc | RegexContains "NS-A'dam" desc -> PublicTransport desc

     | RegexContains "ING AMSTERDAM" desc | RegexContains "ATM 245 AGENCE CENTRE LU" desc -> Cash desc
     | RegexContains "RABOBANK AMSTERDAM" desc -> Cash desc
     | RegexContains "Brugge Markt Brugge" desc -> Cash desc
     
     | RegexContains "POULE-MOULES BRUGGE" desc -> Outing desc
     | RegexContains "CafeRestLand&Zeezich" desc -> Outing desc
     | RegexContains "BURGERMEESTER" desc -> Outing desc
     | RegexContains "Pacific Parc BV" desc -> Outing desc
     | RegexContains "Buurman en Buurman" desc -> Outing desc
     | RegexContains "MCDONALD" desc -> Outing desc
     | RegexContains "CAFE ZURICH AMSTERDA" desc -> Outing desc

     | RegexContains "BIC/ABNANL2A/NAME/K BAL" desc -> Savings desc

     | RegexContains "FA MED BV" desc | RegexContains "AnderZorg NV" desc -> Health desc
     | RegexContains "Specsavers Opticiens" desc -> Health desc
     | RegexContains "APOTHE" desc -> Health desc
     
     | RegexContains "NAME/MOUNTAIN NETWORK BV" desc -> Sport desc
     | RegexContains "De Nieuwe Yogaschool" desc -> Sport desc
     | RegexContains "Pristine Fixed Gear" desc -> Sport desc

     | RegexContains "BRUGGE" desc -> Holidays desc
     | RegexContains "LA PORTE DE FRANCE" desc -> Holidays desc
     | RegexContains "KONRAD LUXEMBOURG" desc -> Holidays desc
     | RegexContains "TUNNEL LIEFKENSHOEK" desc -> Holidays desc

     | RegexContains "INT CARD SERVICES" desc -> CreditCard desc

     | _ -> Others desc

let data = System.IO.File.ReadAllLines (__SOURCE_DIRECTORY__ + "\\input.TAB") 
            |> Seq.map(fun line -> line.Split [|'\t'|]) 
            |> Seq.map (fun tokens -> 
                { id = int(tokens.[0]); 
                    currency = tokens.[1];  
                    date = stringToDate tokens.[2];
                    before = stringToDecimal tokens.[3];
                    after = stringToDecimal tokens.[4];
                    dateAgain = stringToDate tokens.[5];
                    transaction = stringToDecimal tokens.[6];
                    description = getDescription tokens.[7];
                })


let groups = data |> Seq.groupBy getTag

let groupsWithSum = groups  |> Seq.map (fun (group, list) -> 
                    (group, Seq.sumBy (fun i -> i.transaction) list))

let chart = Chart.Pie groupsWithSum;;

let debugOthers = groups |> Seq.filter (fun i -> fst i = "Others") |> Seq.head |> snd |> Seq.map (fun i -> (i.transaction, i.description)) |> Seq.toList;;

chart.ShowChart();;