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
    let matches = System.Text.RegularExpressions.Regex.Matches(input, pattern)
    if matches.Count > 0 then Some input
    else None

let getDescription desc = 
    match desc with
     | RegexContains "BEA.*EkoPlaza" desc -> OrganicGroceries(desc.Substring(33, 20))
     | RegexContains "BEA.*Biomarkt" desc -> OrganicGroceries(desc.Substring(33, 20))
     | RegexContains "BEA.*Marqt" desc -> OrganicGroceries(desc.Substring(33, 20))
     | RegexContains "Estafette Amsterdam" desc -> OrganicGroceries(desc.Substring(33, 20))

     | RegexContains "BEA.*Stach BV" desc -> Groceries(desc.Substring(33, 20))
     | RegexContains "BEA.*ALBERT HEIJN" desc -> Groceries(desc.Substring(33, 20))
     | RegexContains "BEA.*Slagerij" desc -> Groceries(desc.Substring(33, 20))
     | RegexContains "SUPERMARKT 'DE MAROK" desc -> Groceries(desc.Substring(33, 20))
     | RegexContains "Toko Dun Yong" desc -> Groceries(desc.Substring(33, 20))

     | RegexContains "BEA.*HEMA" desc -> HemaAndStuff(desc.Substring(33, 20))
     | RegexContains "BEA.*Kruidvat" desc -> HemaAndStuff(desc.Substring(33, 20))
     | RegexContains "BEA.*Chris Bloemsierkunst" desc -> HemaAndStuff(desc.Substring(33, 20))
     | RegexContains "APOTHE" desc -> HemaAndStuff(desc.Substring(33, 20))

     | RegexContains "Travix Nederland BV" decs -> Salary desc
     | RegexContains "/Booking.com Customer Service Center" desc -> Salary desc

     | RegexContains "RABONL2U/NAME/Tom/REMI" desc -> Rent desc

     | RegexContains "Outlet A'dam AMSTERDAM Z" desc -> Clothes desc
     | RegexContains "H&M" desc -> Clothes desc

     | RegexContains "GVB" desc | RegexContains "NS-A'dam" desc -> PublicTransport desc

     | RegexContains "ING AMSTERDAM" desc | RegexContains "ATM 245 AGENCE CENTRE LU" desc -> Cash desc
     
     | RegexContains "POULE-MOULES BRUGGE" desc -> Outing desc
     | RegexContains "CafeRestLand&Zeezich" desc -> Outing desc
     | RegexContains "BURGERMEESTER" desc -> Outing desc
     | RegexContains "Pacific Parc BV" desc -> Outing desc
     | RegexContains "Buurman en Buurman" desc -> Outing desc
     | RegexContains "MCDONALD" desc -> Outing desc
     
     | RegexContains "BEA" desc -> Transfer (desc.Substring(33, 20))
     | _ -> DirectDebit desc

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


let groups = data |> 
                Seq.groupBy getTag |>
                Seq.map (fun (group, list) -> 
                    (group, Seq.sumBy (fun i -> i.transaction) list))

let chart = Chart.Pie groups;;

chart.ShowChart();;
